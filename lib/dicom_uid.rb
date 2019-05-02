# lib/dicom_uid.rb

# DICOM UID Generator according to the DICOM documentation
# http://dicom.nema.org/dicom/2013/output/chtml/part05/chapter_9.html
# <org>.<suffix>
class DicomUID

  attr_accessor :uid, :name

  def initialize name
    @uid = random_dicom_uid '', nil
    @name = name
  end

  def to_s
    'UID : ' << @uid << ' NAME : ' << @name
  end


  # Generates random component with random, defined, length
  def random_component length, odd_byte_boundary

    # randing length of number
    length_component = length - 1
    loop do
      srand
      length_component = rand(0..length)
      break if length_component != length - 1 and length_component != 0
    end

    # randing the component
    component = (rand ('9' * length_component).to_i).to_s

    if odd_byte_boundary and component[-1].to_i % 2 == 1# if odd number
      component << 'O'
      component = component[1..-1]# removing first int
    end

    component
  end


  # Generate recursively a random dicom uid
  def rand_duid uid, remain, obb
    comp = random_component remain, obb
    remain -= comp.length
    uid << comp

    return uid if remain <= 0

    uid << '.'
    rand_duid uid, remain - 1, obb
  end


  # set default values, with org_root if needed
  # the size of the UID is randomized
  def random_dicom_uid org_root, fixed_size, odd_byte_boundary = true

    # building the org root
    org_root = random_component(64, odd_byte_boundary) if org_root.empty?# UID needs at least an org root
    raise LeadingZeroError if org_root[0] == '0' and org_root.length != 1
    puts org_root
    puts org_root[-2].to_i % 2 == 1
    puts org_root[-1] != 0
    puts odd_byte_boundary
    raise OddByteError if org_root[-2].to_i % 2 == 1 and org_root[-1] != 0 and odd_byte_boundary
    org_root << '.' if org_root[-1] != '.'

    srand
    fixed_size ||= rand 64

    raise OversizedUIDError if fixed_size > 64
    raise RangeError("Size of UID can't be negative") if fixed_size < 0

    # building the suffix
    rand_duid org_root, (fixed_size - org_root.length), odd_byte_boundary
  end

end

# EXCEPTIONS

class LeadingZeroError < StandardError
  def initialize msg = "Can't have a leading 0 in a component with multiple digits"
    super
  end
end

class OddByteError < StandardError
  def initialize msg = "Can't have an odd last byte in a component"
    super
  end
end

class OversizedUIDError < StandardError
  def initialize msg = "UID musn't be more than 64 characters"
    super
  end
end
