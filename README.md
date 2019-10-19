# DICOM UID Generator

Gem generating DICOM random UID


## Documentation

![Here](https://poulpy.github.io/DICOM-UID/docs/)


## Examples

```ruby
DicomUID.random_dicom_uid '10.12.6.64', 60
# 10.12.6.64.427667812798425850151433034003527467011730.452.0
DicomUID.random_dicom_uid '1.1.3.62', 30, false
# 1.1.3.62.5029609471.336514265

DicomUID.random_component 6
# 9538
DicomUID.random_component 30, false
# 59452307
```

