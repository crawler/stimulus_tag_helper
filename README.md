# stimulus_tag_helper

[![Rubocop](https://github.com/crawler/stimulus_tag_helper/actions/workflows/rubocop.yml/badge.svg)](https://github.com/crawler/stimulus_tag_helper/actions/workflows/rubocop.yml)
[![Tests](https://github.com/crawler/stimulus_tag_helper/actions/workflows/test.yml/badge.svg)](https://github.com/crawler/stimulus_tag_helper/actions/workflows/test.yml)
[![Ruby Style Guide](https://img.shields.io/badge/code_style-standard-brightgreen.svg)](https://github.com/testdouble/standard)
[![Gem](https://img.shields.io/gem/v/stimulus_tag_helper.svg)](https://rubygems.org/gems/stimulus_tag_helper)

## ~~WARING!~~

~~This gem is in the proof of concept stage. I made it for myself, and it is not yet covered with tests and documentation.~~

🎉 After around a year from initial publication, the helper is pretty useful and simple enough to be stable and compatible with different Ruby/Rails versions. So I decided to cover it with tests and add fancy badges.

If Russia has not dropped a nuclear bomb on Kyiv then the repo is still maintained by me.

## Description

The stimulusjs is a great js framework for the HTML that you already have, but once you start using it the HTML became wordier, as you need to extend it with more attributes that you already have. So I made this even more modest than the stimulus helper.

Sometimes it makes the template cleaner, sometimes it is not. It's up to you when to use it.

Helper matches Stimulus 2.0+ requirements. You can mix attributes of multiple controllers in a single element or the tag helper. In the end, the stimulus helpers return is a simple Hash.

---

- [Compatibility](#compatibility)
- [Quick start](#quick-start)
- [Examples](#examples)
- [Support](#support)
- [License](#license)
- [Code of conduct](#code-of-conduct)
- [Contribution guide](#contribution-guide)

## Compatibility

**Ruby:** 3.1, 3.0, 2.7; **Rails:** edge, 7.0, 6.1, 6.0

## Quick start

```ruby
gem `stimulus_tag_helper`
```

### In the Rails Controller

```ruby
helper StimulusTagHelper
```

### In the ViewComponent

```ruby
include StimulusTagHelper
```

## Examples

### The controller from the stimulusjs homepage

**Slim Lang:**
```slim
= stimulus_controller("hello", tag: "div") do |sc|
  = text_field_tag('', '', **sc.target("name"))
  = button_tag('Greet', type: 'button', **sc.action("click->greet"))
  span[*sc.target("output")]
```

**Output:**

```html
<div data-controller="hello">
  <input type="text" name="" id="" value="" data-hello-target="name" />
  <button name="button" type="button" data-action="click->hello#greet">Greet</button>
  <span data-hello-target="output"></span>
</div>
```

*To support nesting, and the stimulus 2.0 attributes notation, the actions, and the targets are prefixed with the controller name*


### Initialize the builder and use the controller attribute later

**Slim Lang**

```slim
= stimulus_controller("slideshow") do |sc|
  div[*sc.controller_attribute]
    = button_tag ' ← ', type: 'button', **sc.action("previous")
    = button_tag ' → ', type: 'button', **sc.action("next")
    div[*sc.target("slide")] 🐵
    div[*sc.target("slide")] 🙈
    div[*sc.target("slide")] 🙉
    div[*sc.target("slide")] 🙊
```

**Output:**

```html
<div data-controller="slideshow">
  <button name="button" type="button" data-action="slideshow#previous"> ← </button>
  <button name="button" type="button" data-action="slideshow#next"> → </button>
  <div data-slideshow-target="slide">🐵</div>
  <div data-slideshow-target="slide">🙈</div>
  <div data-slideshow-target="slide">🙉</div>
  <div data-slideshow-target="slide">🙊</div>
</div>
```

### Nested controllers example

**Plain Ruby:**

```ruby
stimulus_controller(:effects) do |ec|
  stimulus_controller(
    :clipboard, tag: :div, **ec.controller_property.merge(ec.action_property("clipboard:copy->flash"))
  ) do |cc|
    safe_join([
      "PIN: ",
      tag.input(**cc.attributes(target: "source"), type: "text", value: "1234", readonly: true),
      tag.button(**cc.action("copy")) { "Copy to Clipboard" }
    ])
  end
end
```

**Output:**

```html
<div data-controller="clipboard effects" data-action="clipboard:copy->effects#flash">
  PIN: <input data-clipboard-target="source" type="text" value="1234" readonly="readonly">
  <button data-action="clipboard#copy">Copy to Clipboard</button>
</div>
```

## Support

If you want to report a bug or have ideas, feedback, or questions about the gem, [let me know via GitHub issues](https://github.com/crawler/stimulus_tag_helper/issues/new) and I will do my best to provide a helpful answer. Happy hacking!

## License

The gem is available as open-source under the terms of the [MIT License](LICENSE.txt).

## Code of conduct

Everyone interacting in this project’s codebases, issue trackers, chat rooms, and mailing lists is expected to follow
the [code of conduct](CODE_OF_CONDUCT.md).

## Contribution guide

Pull requests are welcome!
