function getALEventHandler(eventName, skipIfBusy) {
    return (...args) => new Promise(resolve => {
      var result;
  
      var eventResult = `${eventName}Result`;
      window[eventResult] = alresult => {
        result = alresult;
        delete window[eventResult];
      };
  
      Microsoft.Dynamics.NAV.InvokeExtensibilityMethod(
        eventName,
        args,
        skipIfBusy,
        () => resolve(result));
    });
  }

  function sleep(ms) {
    return new Promise(resolve => setTimeout(resolve, ms));
  }

  function isNull(obj)
  {
   return !(obj && obj !== 'null' && obj !== 'undefined');
  }