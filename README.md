# summernoteDrafts

A summernote plugin for saving and retrieving drafts.

[Demo](https://cdn.rawgit.com/MissAllSunday/summernoteDrafts/5f4786b1/demo.html)


### Setup

requires [store.js](https://github.com/marcuswestin/store.js/) version 2.0 or higher to save/get drafts. See the demo code to get a CDN url for it.

Include lib/summernoteDrafts.js and append both sDraftsLoad and sDraftsSave buttons to your summernote toolbar:

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
	dateFormat: null
	saveIcon: null
	loadIcon: null
  }
});
```
- storePrefix The unique name to help identify each saved draft
- dateFormat a callback to format the date of each draft, accepts a single parameter, a date string in ISO format and should return a formatted date string.

```javascript
dateFormat: function(dateFormat){
	// apply some pretty format to the date here

	return dateFormat;
};
```

By default the plugin shows a date in raw ISO format.

- saveIcon An option to replace the default save text
- loadIcon An option to replace the default load text

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
