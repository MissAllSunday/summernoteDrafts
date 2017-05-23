(function (factory) {
    # global define
    if (typeof define === 'function' && define.amd) {
        # AMD. Register as an anonymous module.
        define(['jquery'], factory);
    } else if (typeof module === 'object' && module.exports) {
        # Node/CommonJS
        module.exports = factory(require('jquery'));
    } else {
        # Browser globals
        factory(window.jQuery);
    }
}(function ($) {

  $.extend $.summernote.options,
  sDrafts:
    storePrefix:'sDrafts',

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
      drafts = store.get(options.storePrefix)

      context.memo 'button.sDraftsSave', () ->
        button = ui.button
          click: (e) ->
            e.preventDefault()
            context.invoke 'sDrafts.show'
            false

        button.render();

      @initialize : ->
        $container = options.dialogsInBody ? $(document.body) : $editor
        body = '<div class="form-group">' + '<label>' + lang.provideName + '</label>' + '<input class="note-link-imgUrl form-control" type="text" /></div>'
        footer = '<button href="#" class="btn btn-primary note-link-btn">' + lang.save + '</button>'

        @$dialog = ui.dialog
          className: 'link-dialog'
          title: lang.save
          fade: options.dialogsFade
          body: body
          footer: footer

        @$dialog.render
        @$dialog.appendTo $container

}));
