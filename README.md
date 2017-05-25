# summernoteDrafts

A summernote plugin for saving and retrieving drafts.

[https://cdn.rawgit.com/MissAllSunday/summernoteDrafts/5f4786b1/demo.html](Demo)


### Setup

requires [https://github.com/marcuswestin/store.js/](store.js) version 2.0 or higher  to store drafts.

Append both buttons to your summernote toolbar:

```javascript
$('.summernote').summernote({
    toolbar:[
        ['misc', ['sDraftsLoad', 'sDraftsSave']]
    ]
});
```

### Options

```javascript
$.extend($.summernote.options, {
  sDrafts: {
	storePrefix: 'sDrafts'
  }
});
```
- storePrefix The unique name to help identify each saved draft
