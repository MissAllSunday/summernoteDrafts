((factory) ->
  if typeof define == 'function' and define.amd
    define [ 'jquery' ], factory
  else if typeof module == 'object' and module.exports
    module.exports = factory(require('jquery'))
  else
    factory window.jQuery
  return
) ($) ->

  $.extend $.summernote.options,
  sDrafts:
    storePrefix:'sDrafts'

  $.extend $.summernote.lang,
  'en-US':
    'sDrafts':
      'save': 'Save'
      'load': 'Load Drafts'
      'select': 'select the draft you want to load'
      'provideName': 'Provide a name for this draft'

  $.extend $.summernote.plugins,
    'sDraftsSave' : (context) ->
      ui = $.summernote.ui
      options = context.options
      lang = options.langInfo.sDrafts
      $editor = context.layoutInfo.editor

      context.memo 'button.sDraftsSave', () ->
        button = ui.button
          click: (e) ->
            e.preventDefault()
            context.invoke 'sDraftsSave.show'
            false
        button.render

      initialize = ->
        $container = if options.dialogsInBody then $(document.body) else $editor
        body = '<div class="form-group">' + '<label>' + lang.provideName + '</label>' + '<input class="note-draftName form-control" type="text" /></div>'
        footer = '<button href="#" class="btn btn-primary note-link-btn">' + lang.save + '</button>'

        @$dialog = ui.dialog
          className: 'link-dialog'
          title: lang.save
          fade: options.dialogsFade
          body: body
          footer: footer

        @$dialog.render
        @$dialog.appendTo $container
        return

      destroy = ->
        ui.hideDialog @$dialog
          .remove
        return

      show = ->
        ui.showDialog @$dialog
        draftName = @$dialog.find '.note-draftName'
          .val
        $saveBtn = @$dialog.find '.note-link-btn'
          .click (e) =>
            e.preventDefault
            @saveDraft draftName
            false

      saveDraft = (name) ->
        isoDate = new Date
          .toISOString
        name ?= isoDate
        store.set options.sDrafts.storePrefix + '-' + name,
          name: name
          sDate: isoDate
          body : context.code
        ui.hideDialog @$dialog

        false
      false

  $.extend $.summernote.plugins,
  'sDraftsLoad' : (context) ->
    ui = $.summernote.ui
    options = context.options
    lang = options.langInfo.sDrafts
    $editor = context.layoutInfo.editor
    drafts = @getDrafts
    htmlList = ''

    for key, draft of drafts
      do ->
        htmlList += '<a class="list-group-item note-draft" data-draft="' + key + '">' + draft.name + '</a>'

    context.memo 'button.sDraftsLoad', () ->
      button = ui.button
        click: (e) ->
          e.preventDefault()
          context.invoke 'sDraftsLoad.show'
          false

      button.render

    initialize : () ->
      $container = if options.dialogsInBody then $(document.body) else $editor
      body = '<div class="list-group">' + htmlList + '</div>'

      @$dialog = ui.dialog
        className: 'link-dialog'
        title: lang.load
        fade: options.dialogsFade
        body: body
        footer: ''

      @$dialog.render
      @$dialog.appendTo $container
      return

    destroy = () ->
      ui.hideDialog @$dialog
        .remove
      return

    show = () ->
      ui.showDialog @$dialog
      $selectedDraft = @$dialog.find '.note-draft'
        .click (e) ->
          e.preventDefault
          div = document.createElement 'div'
          key = $ this
            .data 'draft'
          data = drafts[key]

          if data
            div.innerHTML = data.body
            context.invoke('editor.insertNode', div)

          # if no data show some error or something
          false

    getDrafts = () ->
      drafts = []
      store.each (value, key) ->
        if key.indexOf(options.sDrafts.storePrefix) >= 0
          drafts[key] = value

      return drafts
