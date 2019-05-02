# lib/dicom_uid.rb

# DICOM UID Generator according to the DICOM documentation
# http://dicom.nema.org/dicom/2013/output/chtml/part05/chapter_9.html
# <org>.<suffix>
class DicomUID


  # Generates random component with random, defined, length
  def self.random_component length = 64
    # randing length of number
    length_component = length - 1
    loop do
        srand
        length_component = rand(0..length)
        break if length_component != length - 1 and length_component != 0
    end

    # randing the component
    component = (rand ('9' * length_component).to_i).to_s
    if component[-1].to_i % 2 == 1# if odd number
      component << 'O'
      component = component[1..-1]# removing first int
    end

    component
  end


  # Generate recursively a random dicom uid
  def self.rand_duid uid = '', remain
    comp = self.random_component remain
    remain -= comp.length
    uid << comp

    return uid if remain <= 0

    uid << '.'
    self.rand_duid uid, remain - 1
  end


  # set default values, with org_root if needed
  # the size of the UID is randomized
  def self.random_dicom_uid org_root, fixed_size
    # building the org root
    org_root ||= random_component# UID needs at least an org root
    raise LeadingZeroError if org_root[0] == '0' and org_root.length != 1
    raise OddByteError if org_root[-2].to_i % 2 == 1 and org_root[-1] != 0
    org_root << '.' if org_root[-1] != '.'
    srand
    fixed_size ||= rand 64
    # building the suffix
    return self.rand_duid org_root, (fixed_size - org_root.length)
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