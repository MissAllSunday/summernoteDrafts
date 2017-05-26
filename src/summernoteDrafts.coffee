###
 * @package summernoteDrafts.js
 * @version 1.0
 * @author Jessica González <suki@missallsunday.com>
 * @copyright Copyright (c) 2017, Jessica González
 * @license https://opensource.org/licenses/MIT MIT
###

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
    dateFormat: null
    saveIcon: null
    loadIcon: null

  $.extend $.summernote.lang['en-US'],
    sDrafts :
      save : 'Save draft'
      load : 'Load Drafts'
      select : 'select the draft you want to load'
      provideName : 'Provide a name for this draft'
      saved : 'Draft was successfully saved'
      loaded: 'Draft was successfully loaded'
      deleteAll: 'Delete all drafts'
      noDraft : 'The selected draft couldn\'t be loaded, try again or select another one'
      nosavedDrafts : 'There aren\'t any drafts saved'
      deleteDraft : 'delete'
      youSure : 'Are you sure you want to do this?'

  $.extend $.summernote.plugins,
    'sDraftsSave' : (context) ->
      ui = $.summernote.ui
      options = context.options
      lang = options.langInfo.sDrafts
      $editor = context.layoutInfo.editor

      context.memo 'button.sDraftsSave', () ->
        button = ui.button
          contents: if options.sDrafts.saveIcon then options.sDrafts.saveIcon else lang.save
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
        @$dialog.remove()
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
        keyName = options.sDrafts.storePrefix + '-' + name
        body = context.code()
        store.set keyName,
          name: name
          sDate: isoDate
          body : body
        alert lang.saved
        @destroy()

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
        fDate = if options.sDrafts.dateFormat and typeof options.sDrafts.dateFormat is 'function' then options.sDrafts.dateFormat(draft.sDate) else draft.sDate
        htmlList += "<li class='list-group-item'><a href='#' class='note-draft' data-draft='#{key}'>#{draft.name} - <small>#{fDate}</small></a><a href='#' class='label label-danger pull-right delete-draft' data-draft='#{key}'>#{lang.deleteDraft}</a></li>"

    context.memo 'button.sDraftsLoad', () ->
      button = ui.button
        contents: if options.sDrafts.loadIcon then options.sDrafts.loadIcon else lang.load
        tooltip: lang.load
        click: (e) ->
          e.preventDefault()
          context.invoke 'sDraftsLoad.show'
          false

      button.render()

    @initialize =  =>
      $container = if options.dialogsInBody then $(document.body) else $editor
      body = if htmlList.length then "<h4>#{lang.select}</h4><ul class='list-group'>#{htmlList}</ul>" else "<h4>#{lang.nosavedDrafts}</h4>"
      footer = if htmlList.length then "<button href='#' class='btn btn-primary deleteAll'>#{lang.deleteAll}</button>" else ""

      @$dialog = ui.dialog(
        className: 'link-dialog'
        title: lang.load
        fade: options.dialogsFade
        body: body
        footer: footer).render().appendTo $container
      return

    @destroy = =>
      ui.hideDialog @$dialog
      @$dialog.remove()
      return

    @show = =>
      ui.showDialog @$dialog
      self = @
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
            alert lang.loaded

          else
            alert lang.noDraft

          self.destroy()
          false

      $deleteDraft = @$dialog.find 'a.delete-draft'
        .click (e) ->
          if confirm lang.youSure
            key = $ this
              .data 'draft'
            data = drafts[key]

            if data
              store.remove key
              self = $ this
              self.parent().hide 'slow', ->
                $(this).remove()
                return

            else
              alert lang.noDraft

      $deleteAllDrafts = @$dialog.find 'button.deleteAll'
        .click (e) ->
          selfButton = $ this
          if confirm lang.youSure
            for key, draft of drafts
              do ->
                store.remove key

            uiDialog = self.$dialog.find 'ul.list-group'
              .hide 'slow', ->
                $(this).replaceWith "<h4>#{lang.nosavedDrafts}</h4>"
                selfButton.hide 'slow'
                return

      return
    return
