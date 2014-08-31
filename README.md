# Modelize  [![wercker status](https://app.wercker.com/status/b2028c39b7ff2ea261857eac4db73af3/s "wercker status")](https://app.wercker.com/project/bykey/b2028c39b7ff2ea261857eac4db73af3)[![Code Climate](https://codeclimate.com/github/yonelacort/modelize/badges/gpa.svg)](https://codeclimate.com/github/yonelacort/modelize)

Ruby gem that transforms from **JSON**, **XML**, **Hash** and **CSV** to an instance class with its attributes.

Classes are created in runtime with their corresponding attributes, as well as the attributes values are set.
It also respects the object hierarchy and generates the nested instance classes.

Handy tool to parse and manipulate HTTP responses, files and objects in the format listed above.

## Installation

Add this line to your application's Gemfile:

    gem 'modelize'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install modelize

## Usage

To create the class dynamically and get it instanciated:

```ruby
Modelize.create(source, options)
```

* **source**: Object or file's path.
* **options**:
  * **format** (required): (:xml|:json|:csv|:hash)
  * **file** (false by default):
    * **true**:  When in the source is the path for the file containing the data.
    * **false**: When the object is directly passed in the source param.
  * **separator**: Only for CSV! Points the character used as column separator in the CSV file.
  * **class** (by default nil): Custom class that can be passed to be used as instance class root.
                                Useful to have predefined functions and validations.

 have a look to the examples to see how it works in each case supported.


### Instanciate object from JSON string
```ruby
source = "{
  \"root\" : {
    \"key\" : \"value1\",
    \"array_key\" : [1, 2, 3],
    \"object_key\" : {
      \"sub_key\" : 123
    }
  }
}"

instance = Modelize.create(source, format: :json)
instance.root.key
#=> "value"
instance.root.array_key
#=> [1, 2, 3]
instance.root.object_key.sub_key
#=> 123
```

### Instanciate object from Hash

```ruby
source = {
  "root" => {
    "key" => "value1",
    "array_key" => [1, 2, 3],
    "object_key" => {
      "sub_key" => 123
    }
  }
}

# This format is also supported
# source = {
#   root: {
#     key: "value1",
#     array_key: [1, 2, 3],
#     object_key: {
#       sub_key: 123
#     }
#   }
# }

instance = Modelize.create(source, format: :hash)
instance.root.key
#=> "value"
instance.root.array_key
#=> [1, 2, 3]
instance.root.object_key.sub_key
#=> 123
```

### Instanciate object from XML file

Having the following XML file whose path is ```"path/to/file"```
```xml
<?xml version="1.0" encoding="UTF-8" ?>
<root>
  <key>value1</key>
  <array_key>1</array_key>
  <array_key>2</array_key>
  <array_key>3</array_key>
  <object_key>
    <sub_key1>123</sub_key1>
  </object_key>
</root>
```

```ruby
Modelize.create("path/to/file", format: :xml, file: true)
instance.root.key
#=> "value"
instance.root.array_key
#=> [1, 2, 3]
instance.root.object_key.sub_key
#=> "123"
```
Note, integers and floats will be returned in string format until fix.

### Instanciate object from JSON file

Having a JSON file whose path is ```"path/to/file"```
```json
{
  "root" : {
    "key" : "value",
    "array_key" : [1, 2, 3],
    "object_key" : {
      "sub_key" : 123
    }
  }
}
```

```ruby
Modelize.create("path/to/file", format: :json, file: true)
instance.root.key
#=> "value"
instance.root.array_key
#=> [1, 2, 3]
instance.root.object_key.sub_key
#=> 123
```

### Instanciate object from CSV file

Having this CSV file whose path is ```"path/to/file"```
```csv
id;name;phone;city;height
1;Tom;123;Valencia;1.78
2;Paul;231;Zurich;1.98
```

```ruby
Modelize.create("path/to/file", format: :csv, file: true, separator: ";")
instance.first.name
#=> "Tom"
instance.last.height
#=> "1.98"
```

### Using a custom class as instance root

To give also space to some customization you can define your methods in the **custom** class that you pass.

Given the following source:
```ruby
source = {
  coordinates: {
    lat: 31.1234,
    lng: -0.3562
  }
}
```

Lets pass the class ```Place``` to Modelize
```ruby
class Place
  def latlng
    "#{coordinates.lat},#{coordinates.lng}"
  end
end
```

Now, by making use of this class you can manipulate inner class instances in a predefined way.
```ruby
place = Modelize.create(source, format: :hash, class: Place)
place.latlng
#=> "31.1234,-0.3562"
```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/modelize/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
