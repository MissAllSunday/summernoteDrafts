# summernoteDrafts

A summernote plugin for saving and retrieving drafts.

[Demo](https://cdn.rawgit.com/MissAllSunday/summernoteDrafts/5f4786b1/demo.html)


### Setup

requires [store.js](https://github.com/marcuswestin/store.js/) version 2.0 or higher  to store drafts.

Append both sDraftsLoad and sDraftsSave buttons to your summernote toolbar:

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

### Language strings

```javascript
$.extend($.summernote.lang['en-US'], {
  sDrafts: {
	save: 'Save draft',
	load: 'Load Drafts',
	select: 'select the draft you want to load',
	provideName: 'Provide a name for this draft',
	saved: 'Draft was successfully saved',
	loaded: 'Draft was successfully loaded',
	deleteAll: 'Delete all drafts',
	noDraft: 'The selected draft couldn\'t be loaded, try again or select another one',
	nosavedDrafts: 'There aren\'t any drafts saved',
	deleteDraft: 'delete',
	youSure: 'Are you sure you want to do this?'
  }
});
```
