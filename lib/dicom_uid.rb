# lib/dicom_uid.rb
class DicomUID


  # Generates random component with random, defined, length
  def random_component length = 64
    # randing length of number
    length_component = length - 1
    loop do
        srand
        length_component = rand(0..length)
        break if length_component != length - 1 and length_component != 0
    end

    # randing the component
    (rand ('9' * length_component).to_i).to_s
  end


  # Generate recursively a random dicom uid
  def rand_duid uid = '', remain
    comp = random_component remain
    remain -= comp.length
    uid << comp

    return uid if remain <= 0

    uid << '.'
    rand_duid uid, remain - 1
  end


  # set default values, with org_root if needed
  def random_dicom_uid org_root = '', size = 64
    org_root << '.' if !org_root.empty? and org_root[-1] != '.'
    return rand_duid org_root, size
  end

end
