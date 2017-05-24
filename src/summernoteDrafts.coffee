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
    'sDrafts' : (context) ->
      ui = $.summernote.ui
      options = context.options
      lang = options.langInfo.sDrafts
      $editor = context.layoutInfo.editor
      drafts = store.get options.storePrefix

      context.memo 'button.sDraftsSave', () ->
        button = ui.button
          click: (e) ->
            e.preventDefault()
            context.invoke 'sDrafts.show'
            false

        button.render

      initialize : () ->
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

      destroy = () ->
        ui.hideDialog @$dialog
          .remove
        return

      show = () ->
        ui.showDialog(@$dialog);
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

        return

      return
