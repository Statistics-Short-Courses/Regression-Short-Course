<script>
(function () {
  function markComplete(exId) {
    document.querySelectorAll('.cell.wait[data-check="true"][data-exercise="' + exId + '"]').forEach(function (el) {
      el.setAttribute('data-complete', 'true');
    });
  }

  function handleGradeNode(node) {
    if (!(node instanceof Element)) return;
    if (node.classList.contains('exercise-grade') && node.classList.contains('alert-success')) {
      var host = node.closest('[data-exercise]');
      var exId = host && host.getAttribute('data-exercise');
      if (exId) markComplete(exId);
    } else if (node.querySelectorAll) {
      node.querySelectorAll('.exercise-grade.alert-success').forEach(function (child) {
        var host = child.closest('[data-exercise]');
        var exId = host && host.getAttribute('data-exercise');
        if (exId) markComplete(exId);
      });
    }
  }

  function scanExisting() {
    document.querySelectorAll('.exercise-grade.alert-success').forEach(handleGradeNode);
  }

  document.addEventListener('DOMContentLoaded', function () {
    // Initial pass for any pre-rendered success states
    scanExisting();
    // Observe dynamically added grade alerts
    var mo = new MutationObserver(function (mutations) {
      mutations.forEach(function (m) {
        m.addedNodes && m.addedNodes.forEach(handleGradeNode);
      });
    });
    mo.observe(document.body, { childList: true, subtree: true });
  });
})();
</script>

