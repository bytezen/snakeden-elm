/* ports.js - Chrome 55.0.2883.95 (64-bit)

   It is assumed that "this.Elm" is set
   and valid for this IIFE (i.e. "Window.Elm.Shanghai"
   was set by Shanghai.js beforehand).
 */
; (function() {

  function connectElmWorker(elm) {
    function logPlayerMove (value) {
      console.log(
        '[' + (new Date).toISOString() + ']: ' + value
      );
    }

    /*  "Elm.Snakeden" as in "module Snakeden"
           from file "Snakeden.elm""
           compiled into file "Snakeden.js.
     */
    let elmWorker = elm.Snakeden.worker();

    // log player moves
    elmWorker.ports.movePlayer.subscribe(logPlayerMove);

    return elmWorker;
  }

  function move(worker,player, direction) {
    worker.ports.playerInput.send({
      player: player,
      move: direction
    });
  }


  function scheduleActions(snakeden) {
    function moveAt(player, direction){
      return move.bind(null, snakeden, player, direction );
    }

    function at(delay, func) {
      setTimeout(func, delay);
    }

    const player1 = 'greenPlayer'

    // Make some initial random moves

  }


  const moduleName = 'snakedenPorts';
  let elmWorker = connectElmWorker(this.Elm);
//   scheduleActions(elmWorker);

  if (typeof this[moduleName] === 'undefined') {
    this[moduleName] = {
      move: move.bind(null, elmWorker),
      snakeden: elmWorker
    };
  }

}).call(this);