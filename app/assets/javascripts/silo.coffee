# silo.coffee
#
# The main coffee script of the silo application.
#
# =require jquery
# =require jquery-ui

# Checks the availability of localStorage. Returns true if localStorage
# is available, esle false.
hasStorage = -> !! window.localStorage

# Let's go
do($ = jQuery) ->

  # A simple layer.
  SiloLayer =
    layer: $('<div>').addClass('layer')

    fadeIn: (child) ->
      @child.detach() if @child
      @layer.appendTo('body').fadeIn(200)
      @child = child.appendTo('body').fadeIn(200)

    fadeOut: ->
      @layer.fadeOut 200, -> $(@).detach()
      @child.fadeOut 200, -> $(@).detach()

  # Adds the overlay class to an element and bindes the "show" and the
  # "close" event.
  $.fn.siloOverlay = (options) ->
    settings = $.extend {
      class: 'overlay'
    }, options

    @each ->
      el = $(@).addClass(settings.class)
      el.bind 'show', -> SiloLayer.fadeIn(el)
      el.bind 'close', -> SiloLayer.fadeOut(el)

  # Writes the username to localStorage on submit and sets the focus
  # to the first empty input field.
  $.fn.siloLogin = (options) ->
    settings = $.extend {
      username: 'input[name=username]'
      password: 'input[name=password]'
    }, options

    @each ->
      username = $(@).find(settings.username)
      password = $(@).find(settings.password)

      $(@).submit ->
        localStorage.username = username.val() if hasStorage

      if hasStorage and localStorage.username
        username.val(localStorage.username)

      if username.val().trim().length > 0
        password.focus()
      else
        username.focus()

  # Animates the flash message to a certain CSS class and back.
  $.fn.siloFlash = (options) ->
    settings = $.extend {
      class: 'highlight'
      duration: 400
    }, options

    @each ->
      do(el = $(@)) ->
        el.toggleClass settings.class, settings.duration, ->
          el.toggleClass settings.class, settings.duration

  # Disables links
  $.fn.siloDisabledLinks = -> @.click -> false

  # Defines a master box and several slave boxes. If the master box is
  # checked, all slaves get checked too. If one slave is unchecked, the
  # master gets unchecked.
  $.fn.siloMasterBox = (options) ->
    settings = $.extend {
      masterClass: 'master'
      hard: false
    }, options

    do (el = @) ->
      master = el.filter(".#{settings.masterClass}").change ->
        if $(@).is(':checked')
          el.prop('checked', true)
        else if settings.hard
          el.prop('checked', false)

      el.not(".#{settings.masterClass}").change ->
        master.prop('checked', false) if $(@).not(':checked')

      return el

  # Loads the specified help and connects it with an element.
  $.fn.siloHelp = (url, options) ->
    settings = $.extend {
      helpClass: 'need-help'
      helpText: '?'
    }, options

    do (collection = @) ->
      $.ajax url: url, dataType: 'html', success: (help) ->
        help = $(help).siloOverlay()
        help.find('div.button').click -> help.trigger('close')

        collection.after ->
          $('<div>').addClass(settings.helpClass).text(settings.helpText)
          .fadeIn(600).click -> help.trigger('show')

  # Shows a simple confirmation dialog.
  $.fn.siloConfirmDelete = (options) ->
    settings = $.extend {
      buttonClass: 'button'
      submitClass: 'submit'
      submitText: 'Ok'
      abortClass: 'abort'
      abortText: 'Abort'
      textClass: 'text'
      headerClass: 'header'
      headerText: 'Are you sure?'
      wrapperClass: 'confirm-delete'
      passwordClass: 'password'
      passwordText: 'Confirm with your password.'
    }, options

    makeBox = (type) ->
      $('<div>').addClass(settings["#{type}Class"])

    makeButton = (type) ->
      makeBox(type).addClass(settings.buttonClass).text(settings["#{type}Text"])

    makePassword = ->
      $('<input name="password" type="password">')
      .attr(placeholder: settings.passwordText)

    @each ->
      do (el = $(@)) ->
        el.click ->
          dialog = makeBox('wrapper').siloOverlay()
          password = makePassword()

          submit = makeButton('submit').click ->
            el.closest('form').append(password.clone()).submit()

          abort = makeButton('abort').click -> dialog.trigger('close')

          dialog.append ->
            makeBox('header').append(submit, abort).prepend ->
              $('<h2>').text(settings.headerText)

          dialog.append ->
            makeBox('text').append ->
              makeBox('content').text(el.data('confirm'))
            .append ->
              if el.hasClass(settings.passwordClass)
                makeBox('password').append(password)

          dialog.trigger('show')
          return false

  # Handles groups in multi select boxes.
  $.fn.siloMultiSelectGroup = (options) ->
    settings = $.extend {
      activeGroup: 4
      groupClass: 'group'
      counterClass: 'counter'
    }, options

    @each ->
      el = $(@).accordion(autoHeight: false, active: settings.activeGroup)

      el.find('ul').each ->
        ul = $(@)
        counter = ul.prev('h3').find(".#{settings.counterClass}")
        input = ul.find('input')
        input.siloMasterBox(masterClass: settings.groupClass, hard: true)

        input.bind 'count', ->
          counter.text ->
            input.filter(":checked:not(.#{settings.groupClass})").length

        input.trigger('count').change -> $(@).trigger('count')

  # Handles a multi select overlay.
  $.fn.siloMultiSelectOverlay = (options) ->
    settings = $.extend {
      selected: []
      submitClass: 'submit'
      abortClass: 'abort'
      selectClass: 'select'
      grouped: false
    }, options

    # Connects the multi select overlay with an input field.
    @connectWith = (input, name) ->
      @each ->
        el = $(@)
        hidden = $('<input>').attr(name: name, type: 'hidden')
        input.after(hidden)

        el.bind 'submit', ->
          [ids, val] = [[], []]

          el.find("input:checked:not(.#{settings.groupClass})").each ->
            ids.push $(@).attr('name')
            val.push $(@).data('name')

          hidden.val ids.join(' ')
          input.val val.join(', ')
          el.trigger('close')

        el.trigger('submit')

    # Inits the overlay
    @each ->
      do (el = $(@)) ->
        el.siloOverlay()
        el.find(".#{settings.abortClass}").click -> el.trigger('close')
        el.find(".#{settings.submitClass}").click -> el.trigger('submit')

        for id in settings.selected
          el.find("input[name=#{id}]").prop('checked', true)

        if settings.grouped
          el.find(".#{settings.selectClass}").siloMultiSelectGroup(settings)

  # Makes a text field multi selectable.
  $.fn.siloMultiSelect = (name, url, options) ->
    settings = $.extend {
      groupClass: 'group'
      storagePrefix: 'multi-select-'
    }, options

    do (collection = @) ->
      # Retrieve the multi select overlay and boot it up.
      $.ajax url: url, dataType: 'html', success: (select) ->
        select = $(select).siloMultiSelectOverlay(settings)

        collection.prop('disabled', false).focus ->
          select.trigger('show')

        collection.each ->
          select.connectWith($(@), name)

      # Disable input while loading and prevent sending of the long text
      # values by submitting the form to avoid 414. Use localStorage instead.
      collection.prop('disabled', true).each ->
        do (el = $(@)) ->
          storageKey = settings.storagePrefix + el.attr('name')
          el.removeAttr('name')

          if settings.selected.length > 0 && hasStorage
            el.val(localStorage[storageKey])

          el.closest('form').submit ->
            localStorage[storageKey] = el.val() if hasStorage
