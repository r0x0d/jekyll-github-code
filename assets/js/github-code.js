/**
 * GitHub Code Block - Copy functionality
 * Compatible with Jekyll Chirpy theme
 */
(function() {
  'use strict';

  function initGitHubCode() {
    // Event delegation for copy buttons
    document.addEventListener('click', function(event) {
      // Find if click was on or inside a copy button
      var button = event.target;
      while (button && !button.classList.contains('github-code-copy')) {
        button = button.parentElement;
      }
      
      if (!button) return;
      
      event.preventDefault();
      event.stopPropagation();
      
      var codeBlock = button.closest('.github-code-block');
      if (!codeBlock) return;

      var codeElement = codeBlock.querySelector('code');
      if (!codeElement) return;

      var text = codeElement.textContent || codeElement.innerText || '';

      // Copy to clipboard
      if (navigator.clipboard && typeof navigator.clipboard.writeText === 'function') {
        navigator.clipboard.writeText(text).then(function() {
          showCopiedState(button);
        }).catch(function() {
          fallbackCopy(text, button);
        });
      } else {
        fallbackCopy(text, button);
      }
    });
  }

  function fallbackCopy(text, button) {
    var textArea = document.createElement('textarea');
    textArea.value = text;
    textArea.style.cssText = 'position:fixed;left:-9999px;top:-9999px;';
    document.body.appendChild(textArea);
    textArea.focus();
    textArea.select();
    
    try {
      document.execCommand('copy');
      showCopiedState(button);
    } catch (err) {
      console.error('Copy failed:', err);
    }
    
    document.body.removeChild(textArea);
  }

  function showCopiedState(button) {
    if (!button) return;
    
    var originalHTML = button.innerHTML;
    button.classList.add('copied');
    button.innerHTML = '<svg viewBox="0 0 16 16" width="16" height="16"><path fill="currentColor" d="M13.78 4.22a.75.75 0 010 1.06l-7.25 7.25a.75.75 0 01-1.06 0L2.22 9.28a.75.75 0 011.06-1.06L6 10.94l6.72-6.72a.75.75 0 011.06 0z"/></svg>';
    
    setTimeout(function() {
      if (button) {
        button.classList.remove('copied');
        button.innerHTML = originalHTML;
      }
    }, 2000);
  }

  // Initialize when DOM is ready
  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', initGitHubCode);
  } else {
    initGitHubCode();
  }
})();
