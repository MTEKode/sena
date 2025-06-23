// app/javascript/channels/chat_channel.js
import consumer from "channels/consumer";

// consumer.subscriptions.create(
//     { channel: "ChatChannel", chat_id: document.getElementById('chat-id').value },
//     {
//         received(data) {
//             // Utiliza la función addMessage expuesta globalmente
//             if (typeof window.addMessage === 'function') {
//                 const json_data = JSON.parse(data);
//                 window.addMessage('bot', json_data.message);
//             } else {
//                 console.error('addMessage is not defined globally');
//             }
//         }
//     }
// );
