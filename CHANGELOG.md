# Changelog

## 0.4.0

* Add `outlet` selector attributes support

```ruby
  stimulus_controller_tag("clipboard", tag: :div, outlet: {items: ".items"})
```
## Becomes
```html
  <div data-controller="clipboard" data-clipboard-items-outlet=".items"></div>
```

## 0.3.0

* Add `StimulusControllerBuilder#capture` so builder can be created, stored and accessed outside block scope this can
  be usefoul for the ViewComponents

  ```ruby
  class ClipboardComponent < ApplicationComponent
    def call
      clipboard_controller.capture { input }
    end

    def clipboard_controller
      @clipboard_controller ||= t.stimulus_controller("clipboard", tag: :div)
    end

    def input
      t.tag.input(**clipboard_controller.attributes(target: "source"), type: "text", value: "1234", readonly: true)
    end
  end
  ```

* Add `StimulusControllerBuilder#properties` method

## 0.2.1

* Fix `StimulusControllerBuilder` methods generation bug

## 0.2.0

* Cover with the tests
* Minor refactoring and a cleanup, but because of the missing tests, can't tell if it breaks something or not
* Replace autoloading with the [zeitwerk](https://github.com/fxn/zeitwerk)
* Update all gems to the latest versions
* Setup tests workflow
