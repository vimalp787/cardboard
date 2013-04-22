# Cardboard

## Installation

Add the gem to the gemfile
```
gem 'cardboard'
bundle install
```

Run the generator
```
rails g cardboard:install
rake db:migrate
```

Edit your `config/pages.yaml` file then run
```
rake db:seed
```


## Usage

### Fetch a page part
```ruby
@page.get("slideshow")
```
Get returns an active record collection. 
This means that regular Rails methods such as `where`, `limit`, `first`, `each`, etc can be used on page parts

### Fetch a single field
```ruby
@page.get("intro").first.attr("text1")
```
Or
```ruby
@page.get("slideshow").fetch("pepople_count > 5")
```

If this part is **not repeatable** you can use the shorthand notation
```ruby
@page.get("intro.text1")
```


### Image Fields methods

```ruby
image.width               # => 280
image.height              # => 355
image.aspect_ratio        # => 0.788732394366197
image.portrait?           # => true
image.landscape?          # => false
image.depth               # => 8
image.number_of_colours   # => 34703
image.format              # => :png
image.image?              # => true - will return true or false for any content

image.thumb('40x30')              # same as image.process(:thumb, '40x30')

#thumb options
'400x300'            # resize, maintain aspect ratio
'400x300!'           # force resize, don't maintain aspect ratio
'400x'               # resize width, maintain aspect ratio
'x300'               # resize height, maintain aspect ratio
'400x300>'           # resize only if the image is larger than this
'400x300<'           # resize only if the image is smaller than this
'50x50%'             # resize width and height to 50%
'400x300^'           # resize width, height to minimum 400,300, maintain aspect ratio
'2000@'              # resize so max area in pixels is 2000
'400x300#'           # resize, crop if necessary to maintain aspect ratio (centre gravity)
'400x300#ne'         # as above, north-east gravity
'400x300se'          # crop, with south-east gravity
'400x300+50+100'     # crop from the point 50,100 with width, height 400,300
```


## Customization

### Settings
You can create new settings that will be editable from the admin panel. 

```
app
|- models
  |- cardboard
    |- setting.rb
```

```ruby
Cardboard::Setting.create(name: "my_custom_setting", default_value: "something", format: "string")
```

Then you can use this setting in your views or controllers like so:
```ruby
Cardboard::Setting.my_custom_setting
```

## License
This project rocks and uses MIT-LICENSE.