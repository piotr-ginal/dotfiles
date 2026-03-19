# Dev Tools

Utilities and helpers used during the development of these dotfiles.

Scripts and other tools that make maintaining and testing configurations easier.

## `vimium_c_hints_exclude_generator.py`

Identify problematic elements to exclude them :

```javascript
document.addEventListener('click', function(event) {
    console.log("Busted! The clicked element is:", event.target);
}, true);
```
