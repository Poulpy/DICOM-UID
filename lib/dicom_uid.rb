# DICOM UID Generator according to the DICOM documentation
# http://dicom.nema.org/dicom/2013/output/chtml/part05/chapter_9.html
#
# The UID looks like the following <org>.<suffix>
# UID is composed of two main components, org and suffix. Components are separated by a dot and are only composed of decimals.
# The UID must not be more than 64 characters, dots included.
module DicomUID#:nodoc:

  # Maximum size of an UID
  MAXIMUM_SIZE = 64


  # Generates random component with defined, maximum length
  # The maximum length is 62. Why ? Because an UID has at least an org_root
  # and a suffix, and they are separated by a dot, which makes
  # 1 character minimum and 62 characters maximum
  def self.random_component length = 62, odd_byte_boundary = true

    # exceptions
    raise TypeError unless length.is_a? Integer and odd_byte_boundary == !!odd_byte_boundary
    raise RangeError, "Length of a component cannot be negative or null" if length <= 0
    raise OversizedUIDError if length > 62

    # randing length of number
    length_component = length - 1
    loop do
      srand
      length_component = rand 0..length
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




  # set default values, with org_root if needed
  # the size of the UID is randomized
  # fixed_size is the size ogf the whole UID, with the org taken into account
  def self.random_dicom_uid org_root, fixed_size, odd_byte_boundary = true

    raise TypeError, 'Org root must be a string or an Integer' unless org_root.is_a? String or org_root.is_a? Integer
    org_root = org_root.to_s if org_root.is_a? Integer
    raise TypeError unless fixed_size.is_a? Integer and odd_byte_boundary == !!odd_byte_boundary

    # building the org root
    org_root = self.random_component(62, odd_byte_boundary) if org_root.empty?# UID needs at least an org root
    raise LeadingZeroError if org_root[0] == '0' and org_root.length != 1
    puts 'ORG : ' << org_root
    raise OddByteError if !odd_byte_rule(org_root) and odd_byte_boundary

    # if the fixed size doesn't exist, a random one is created, but
    # it must be generated so that the UID musn't be above 64 chars
    fixed_size ||= rand(0..(64 - org_root.length - 1))
    fixed_size -= org_root.length
    fixed_size -= 1 if add_missing_dot org_root

    raise OversizedUIDError if fixed_size > 64 or fixed_size + org_root.length > 64
    raise RangeError("Size of UID can't be negative") if fixed_size < 0

    # building the suffix
    self.rand_duid org_root, (fixed_size - org_root.length), odd_byte_boundary
  end



  def self.random_uids org_root, fixed_size, array_size, odd_byte_boundary = true
    uids = Array.new

    array_size.times do
      uids << (self.random_dicom_uid org_root, fixed_size, odd_byte_boundary)
    end

    uids
  end



  private

  # Generates recursively a random dicom uid
  def self.rand_duid uid, remain, obb = true

    # Exceptions
    raise TypeError unless uid.is_a? String and remain.is_a? Integer and obb == !!obb
    remain -= 1 if add_missing_dot uid
    raise OversizedUIDError if uid.length > 64 or (uid.length + remain > 64)
    raise RangeError, "Remaining characters can't be negative or null" if remain <= 0

    comp = self.random_component remain, obb
    remain -= comp.length
    uid << comp

    return uid if remain <= 0

    uid << '.'
    self.rand_duid uid, remain - 1, obb
  end






end


def add_missing_dot comp
  raise TypeError unless comp.is_a? String
  if comp[-1] != '.'
    comp << '.'
    return true
  end
  false
end


def odd_byte_rule comp
  return comp[-1].to_i % 2 == 0 || (comp[-2].to_i % 2 == 1 && comp[-1].to_i == 0) if comp.length != 1
  comp[-1].to_i % 2 == 0
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
