(function () {
  function readIIDFromMeta() {
    var m = document.querySelector('meta[name="d2dockerinstance"]');
    return m && m.content ? m.content.trim() : "";
  }

  // Inicializa: META tem prioridade. Se META existir, grava no sessionStorage.
  function initIID() {
    var fromMeta = readIIDFromMeta();
    try {
      if (fromMeta) {
        sessionStorage.setItem("D2DockerInstance", fromMeta); // sobrescreve
        return fromMeta;
      }
      // Se não houver META (p.ex., página externa), usa o que já estava salvo
      var stored = sessionStorage.getItem("D2DockerInstance");
      return stored || "";
    } catch (e) {
      // Sem acesso ao sessionStorage (modo privado, etc.)
      return fromMeta || "";
    }
  }

  // Executa a inicialização
  var IID = initIID();

  // fetch: injeta X-D2DockerInstance (sempre lendo o valor mais atual)
  var _fetch = window.fetch;
  window.fetch = function (input, init) {
    init = init || {};
    var headers = new Headers(init.headers || {});
    var val = "";
    try { val = sessionStorage.getItem("D2DockerInstance"); } catch (e) {}
    if (!val) val = readIIDFromMeta();
    if (val) headers.set("X-D2DockerInstance", val);
    init.headers = headers;
    return _fetch(input, init);
  };

  // XHR: injeta X-D2DockerInstance (sempre lendo o valor mais atual)
  var _open = XMLHttpRequest.prototype.open;
  var _send = XMLHttpRequest.prototype.send;

  XMLHttpRequest.prototype.open = function () {
    this.__d2d_should_set__ = true;
    return _open.apply(this, arguments);
  };

  XMLHttpRequest.prototype.send = function (body) {
    try {
      if (this.__d2d_should_set__) {
        var val = "";
        try { val = sessionStorage.getItem("D2DockerInstance"); } catch (e) {}
        if (!val) val = readIIDFromMeta();
        if (val) this.setRequestHeader("X-D2DockerInstance", val);
      }
    } catch (e) {}
    return _send.call(this, body);
  };
})();
