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

  $.extend $.summernote.lang['en-US'],
    sDrafts :
      save : 'Save draft'
      load : 'Load Drafts'
      select : 'select the draft you want to load'
      provideName : 'Provide a name for this draft'
      saved : 'Draft was successfully saved'

  $.extend $.summernote.plugins,
    'sDraftsSave' : (context) ->
      ui = $.summernote.ui
      options = context.options
      lang = options.langInfo.sDrafts
      $editor = context.layoutInfo.editor

      context.memo 'button.sDraftsSave', () ->
        button = ui.button
          contents: lang.save
          tooltip: lang.save
          click: (e) ->
            e.preventDefault()
            context.invoke 'sDraftsSave.show'
            false
        button.render()

      @initialize = =>
        $container = if options.dialogsInBody then $(document.body) else $editor
        body = "<div class='form-group'><label>#{lang.provideName}</label><input class='note-draftName form-control' type='text' /></div>"
        footer = "<button href='#' class='btn btn-primary note-link-btn'>#{lang.save}</button>"

        @$dialog = ui.dialog(
          className: 'link-dialog'
          title: lang.save
          fade: options.dialogsFade
          body: body
          footer: footer).render().appendTo $container
        return

      @destroy = =>
        ui.hideDialog @$dialog
        return

      @show = =>
        ui.showDialog @$dialog
        $saveBtn = @$dialog.find '.note-link-btn'
          .click (e) =>
            e.preventDefault
            draftName = @$dialog.find '.note-draftName'
              .val()
            @saveDraft draftName
            false

      @saveDraft = (name) =>
        isoDate = new Date()
          .toISOString()
        name ?= isoDate
        name = options.sDrafts.storePrefix + '-' + name
        body = context.code()
        store.set name,
          name: name
          sDate: isoDate
          body : body
        alert lang.saved
        ui.hideDialog @$dialog

        return
      return

  $.extend $.summernote.plugins,
  'sDraftsLoad' : (context) ->
    ui = $.summernote.ui
    options = context.options
    lang = options.langInfo.sDrafts
    $editor = context.layoutInfo.editor
    drafts = []
    store.each (key, value) ->
      if typeof key is 'string' and key.indexOf(options.sDrafts.storePrefix) >= 0
        drafts[key] = value
    htmlList = ''

    for key, draft of drafts
      do ->
        htmlList += "<a href='#' class='list-group-item note-draft' data-draft='#{key}'> #{draft.name} <small>#{draft.sDate}</small></a>"

    context.memo 'button.sDraftsLoad', () ->
      button = ui.button
        contents: lang.load
        tooltip: lang.load
        click: (e) ->
          e.preventDefault()
          context.invoke 'sDraftsLoad.show'
          false

      button.render()

    @initialize =  =>
      $container = if options.dialogsInBody then $(document.body) else $editor
      body = "<div class='list-group'>#{htmlList}</div>"

      @$dialog = ui.dialog(
        className: 'link-dialog'
        title: lang.load
        fade: options.dialogsFade
        body: body
        footer: '').render().appendTo $container
      return

    @destroy = =>
      ui.hideDialog @$dialog
      return

    @show = =>
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
        return
      return
    return
