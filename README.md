# stimulus_tag_helper

[![Rubocop](https://github.com/crawler/stimulus_tag_helper/workflows/Rubocop/badge.svg)](https://github.com/crawler/stimulus_tag_helper/actions)

[![Gem](https://img.shields.io/gem/v/stimulus_tag_helper.svg)](https://rubygems.org/gems/stimulus_tag_helper)

## WARING!

This gem is in the proof of concept stage. I made it for myself, and it is not yet covered with tests and the documentation.

## Description

The stimulusjs is a great js framework for the HTML that you already have, but once u start using it the HTML becomes pretty big as you need to extend it with the attributes that your required to tight it with controllers. So I made this modest (even more modest than the stimulus itself) helper. Currently, I use it with the Slim(http://slim-lang.com/). So for now examples will be in it.

The Builder keeps the controller name and then adds it automatically where it is needed to match nesting and Stimulus 2.0 requirements. 
So You can mix attributes of a couple of controllers on a single element or element helper. In the end, the helpers are returning simple Hash.

---

- [Quick start](#quick-start)
- [Examples](#examples)
- [Support](#support)
- [License](#license)
- [Code of conduct](#code-of-conduct)
- [Contribution guide](#contribution-guide)

## Quick start

```ruby
gem 'stimulus_tag_helper', github: 'crawler/stimulus_tag_helper'
```

### In the rails Controller

```ruby
helper StimulusTagHelper
```

### In the ViewComponent

```ruby
include StimulusTagHelper
```

## Examples

Some examples is taken from the real app so may be not very)

### "Hello, Stimulus" controller from the stimulusjs homepage

```slim
= stimulus_controller("hello", tag: "div") do |sc|
  = text_field_tag('', '', **sc.target("name"))
  = button_tag('Greet', type: 'button', **sc.action("click->greet"))
  span[*sc.target("output")]
```

Please note that to support nesting, and the stimulus 2.0 attributes notation, the actions and the targets will be prefixed with controller name

So example above will became:

```html
<div data-controller="hello">
  <input type="text" name="" id="" value="" data-hello-target="name" />
  <button name="button" type="button" data-action="click->hello#greet">Greet</button>
  <span data-hello-target="output"></span>
</div>
```


## "Slideshow" define controller without tag rendering

(buttons messed up for the demonstation purposes)

```slim
= stimulus_controller("slideshow") do |sc|
  div[*sc.controller_attribute]
    = button_tag ' ← ', type: 'button', **sc.action("previous")
    button[*sc.action("next")]
      '  →
    div[*sc.target("slide")] 🐵
    div[*sc.target("slide")] 🙈
    div[*sc.target("slide")] 🙉
    div[*sc.target("slide")] 🙊
```

Became:

```html
<div data-controller="slideshow">
  <button name="button" type="button" data-action="slideshow#previous"> ← </button>
  <button data-action="slideshow#next"> → </button>
  <div data-slideshow-target="slide">🐵</div>
  <div data-slideshow-target="slide">🙈</div>
  <div data-slideshow-target="slide">🙉</div>
  <div data-slideshow-target="slide">🙊</div>
</div>
```

### Nested controllers

Almost random peace of code from my app 

```slim
= stimulus_controller( \
    "flash", tag: "div", class: "flash flash_global", values: { "page-cached" => page_will_be_cached?, src: flash_path },
    actions: %w[flash-message:connect->registerMessage flash-message:disconnect->removeMessage] \
  ) do |fc|
  - unless page_will_be_cached?
    - flash.keys.each do |type|
      .flash__message
        = stimulus_controller( \
            "flash-message",
            tag: "div", class: "flash-message flash-message_type_#{type}",
            actions: %w[animationend->next click->hide] \
          ) do |fmc|
          .flash-message__text = flash[type]
          button.flash-message__dismiss-button[aria-label="Close flash message" *fmc.action("dismiss")]
            = svg_sprite "icons/common.svg#common-times", class: "icon"

```


## Support

If you want to report a bug, or have ideas, feedback or questions about the gem, [let me know via GitHub issues](https://github.com/crawler/stimulus_tag_helper/issues/new) and I will do my best to provide a helpful answer. Happy hacking!

## License

The gem is available as open source under the terms of the [MIT License](LICENSE.txt).

## Code of conduct

Everyone interacting in this project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](CODE_OF_CONDUCT.md).

## Contribution guide

Pull requests are welcome!
