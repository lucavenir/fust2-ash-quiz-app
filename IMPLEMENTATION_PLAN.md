# Piano di implementazione ITS PROTOCOL

Stato: requisiti funzionali, nome ufficiale, direzione visiva e durata iniziale concordati.
Questo documento pianifica l'implementazione; non attesta funzionalità già implementate.

## Requisiti concordati

- Frontend Phoenix LiveView; dominio e persistenza Ash/AshPostgres.
- Nome ufficiale e visibile: ITS PROTOCOL. I moduli applicativi possono mantenere il namespace Itsquitz.
- Lobby unica su `/lobby`, accessibile dal QR con il solo nickname.
- Il GenServer della lobby forma automaticamente gruppi appena ci sono quattro partecipanti.
- Gruppo e stanza sono lo stesso concetto. Ogni gruppo contiene esattamente quattro persone.
- Prima dell'avvio l'admin può modificare i gruppi; l'avvio richiede un comando amministrativo.
- Il server genera un nome simpatico per il gruppo, evitando collisioni tra quelli della giornata.
- Dieci domande distinte estratte casualmente e ordinate per difficoltà numerica.
- I membri di un gruppo ricevono la stessa sequenza e avanzano individualmente dopo ogni risposta.
- Ogni domanda ha testo, quattro opzioni, una sola opzione corretta, argomento, difficoltà, punti,
  spiegazione e immagine opzionale.
- Gli argomenti sono modificabili: l'elenco attuale di atom non è definitivo.
- Un unico limite temporale copre tutte le dieci domande. Durata iniziale di cinque minuti
  (300 secondi), configurabile dall'admin.
- Risposta definitiva al primo invio. Corretta: punti della domanda; errata o assente: zero.
- Soluzioni, spiegazioni e punteggio personale sono mostrati soltanto alla fine individuale.
- Chi termina può accedere subito al modulo privato; il totale del gruppo attende tutti i membri.
- Punteggio di gruppo uguale alla somma dei quattro punteggi individuali.
- Top 10 giornaliera individuale e di gruppo, pubblica e con vista da proiettare.
- Pubblicamente compaiono nickname e nome del gruppo con i quattro nickname.
- Pari punteggio significa pari merito. Non si gestisce l'estensione della top 10 per parità al taglio.
- Una sola partecipazione per identità conosciuta; senza account non è possibile riconoscere una
  persona che si presenta con una nuova identità.
- Recupero tramite codice numerico breve associato al partecipante.
- Modulo dati facoltativo; se inviato richiede nome, cognome, email, classe da 1 a 5 e istituto libero.
- I dati personali servono per contatti successivi e gadget; rimangono privati e separati dalle
  proiezioni pubbliche. Testo informativo e tempi di conservazione non sono ancora definiti.
- Admin tramite codice condiviso hard coded verificato sul server, senza account individuali.
- Una sola istanza, indicativamente dieci gruppi contemporanei. Deployment fuori scope.
- Nessun recupero delle partite attive dopo crash del relativo GenServer o riavvio applicativo.
- Nessun export, invio email o multilingua nella prima versione.

## Convenzioni proposte per i dettagli residui

- FIFO per la coda della lobby; gli ultimi uno, due o tre giocatori attendono altri ingressi.
- Il countdown del gruppo parte all'avvio amministrativo e continua durante le disconnessioni.
- La durata e la sequenza vengono congelate all'avvio: le modifiche admin valgono per i nuovi avvii.
- All'esaurimento del tempo vengono finalizzati i partecipanti ancora attivi; le domande non
  risposte valgono zero. I partecipanti già arrivati alla decima risposta mantengono il loro risultato.
- I risultati individuali finalizzati sono subito eleggibili per la classifica individuale;
  un gruppo entra nella classifica di gruppo solo quando tutti e quattro sono finalizzati.
- Modifiche ai gruppi consentite solo prima dell'avvio, con scambio di membri per preservare i quartetti.
- Annullamento amministrativo prima o durante la partita; nessuna pausa o riavvio della stessa partita.
  Un gruppo annullato non produce risultati validi per le classifiche.
- Codice di recupero proposto a sei cifre, univoco tra i partecipanti recuperabili. Un cookie di
  sessione evita di doverlo reinserire dopo ogni refresh; il codice resta l'alternativa manuale.
- La stessa identità non può rispondere due volte aprendo più tab: decide il server.
- Classifiche filtrate per data locale di conclusione in `Europe/Rome`, tradotta in intervallo UTC
  semiaperto per interrogare il database. Limite massimo dieci record; ordine secondario stabile
  per i pari punteggio, senza attribuire loro posizioni diverse.
- Estrazione dall'intero insieme delle domande disponibili, senza quote per argomento;
  ordinamento per difficoltà crescente. Difficoltà uguali sono ammesse.
- Le domande usate in una partita sono congelate: il CRUD successivo non modifica lo storico.
- Se il processo di gruppo muore, il gruppo diventa interrotto e non viene ricreato come partita attiva.
  I risultati individuali già finalizzati rimangono; non si crea un risultato di gruppo completo.
- Nessuna nuova infrastruttura immagini: upload locale persistente fuori dai bundle compilati,
  percorso configurabile e pubblicazione tramite rotta dedicata. Testo alternativo nel CRUD.

## Stato attuale e modello dati

Il dominio `Itsquitz.Game` contiene `Quiz`, `Partecipant` e `Answer`.
`Quiz` oggi modella una domanda; `Answer` ha chiave composta domanda/partecipante e non distingue partite.
Il router espone la home generata; AshAdmin è attualmente disponibile solo con `dev_routes`.

Prima di rinominare risorse e tabelle verificare se esistono dati da preservare. Le migrazioni
devono essere generate con Ash e revisionate, senza riscrivere migrazioni già applicate.

Risorse proposte:

| Risorsa | Responsabilità |
| --- | --- |
| Question (oggi Quiz) | Banca domande, quattro opzioni, risposta corretta, punti, difficoltà, spiegazione, immagine |
| Topic | Argomenti modificabili dall'admin, riferiti dalle domande |
| Participant (oggi Partecipant) | Nickname, codice di recupero e identità anonima |
| Group | Quartetto/partita, nome generato, stato, durata congelata, inizio e scadenza |
| Participation | Collegamento partecipante/gruppo, progresso e risultato individuale finalizzato |
| GroupQuestion | Posizione 1–10 e copia della domanda utilizzata, incluse opzioni, soluzione, punti e immagine |
| Answer | Risposta della partecipazione a una GroupQuestion, istante, correttezza e punti assegnati |
| ContactDetails | Dati facoltativamente forniti a fine gioco, accessibili solo al partecipante e agli admin |

Il risultato individuale è persistito su Participation; quello di gruppo su Group. Non serve
una tabella separata di leaderboard: letture ordinate dei risultati finalizzati della giornata.
Vincoli DB impediscono risposte duplicate e posizioni duplicate delle domande nella stessa partita.

## Architettura OTP e confini Ash

- `LobbyServer`: coda unica, ingresso, uscita e formazione dei quartetti.
- `GroupServer`: un GenServer per gruppo, registrato tramite Registry e supervisionato da
  DynamicSupervisor. Stato serializzabile: identità, progressi, scadenza e versione degli eventi.
- `Phoenix.PubSub`: notifiche alla lobby, ai partecipanti e alle classifiche. I topic pubblici non
  contengono soluzioni, codici di recupero o dati personali.
- Azioni Ash specifiche e code interface: ingresso, assegnazione, avvio, risposta, finalizzazione,
  annullamento, letture autorizzate e invio dei dati personali. Le LiveView non accedono direttamente al Repo.
- Il GenServer serializza i comandi e governa il tempo; azioni e validazioni Ash stabiliscono
  invarianti, autorizzazioni e persistenza. Le scritture persistenti non richiamano sincronicamente
  lo stesso GenServer che le ha invocate.
- La risposta è confermata e il progresso avanzato solo dopo la scrittura riuscita. Rifiuto di
  invii tardivi, duplicati, relativi ad altre domande o ad altre partecipazioni.
- Scadenza verificata lato server anche quando il messaggio del timer viene elaborato in ritardo.
  Orologio monotono per il controllo operativo; timestamp UTC per lo storico.
- Timer globale visualizzato tramite un piccolo hook JS; il browser non determina punteggi o scadenze.
- Finalizzazione idempotente. La chiusura persiste il risultato di gruppo prima della notifica conclusiva.
- Nessuna risposta corretta viene inviata al browser prima della conclusione individuale.
- I processi di gruppo sono temporanei: niente ripartenza automatica di partite perse.
  Il processo della lobby monitora la terminazione dei gruppi; all'avvio applicativo i gruppi
  rimasti attivi nel database vengono marcati interrotti senza ricostruirne lo stato di gioco.

## UI di riferimento

Fonti: `../context/ITS-PROTOCOL-mockup.html` e `../context/itsprotocol/`.

Direzione visiva scelta: stile chiaro delle pagine separate in `../context/itsprotocol/`,
con bianco/grigio chiaro, rosso, Inter e dettagli pixel Press Start 2P.
Il nome visibile è ITS PROTOCOL, senza il suffisso GAMES presente negli esempi.
Il mockup unico rimane un riferimento secondario per composizione e gerarchia visiva.

Elementi comuni da mantenere: tipografia marcata, CTA grandi, card arrotondate, indicatori di
progresso, timer leggibile, enfasi sul proprio risultato e leaderboard adatta alla proiezione.
Font inclusi localmente nei bundle/asset del progetto.

Adattamenti ai requisiti:
- Ingresso senza codice di stanza; il codice compare solo come recupero personale.
- Attesa prima nella lobby unica, poi nel quartetto con nome generato e quattro nickname.
- Domanda e immagine sul dispositivo del giocatore, insieme alle quattro opzioni complete.
- Timer unico della partita e progresso individuale 1–10; nessuna soluzione o punteggio in corsa.
- Risultati personali e spiegazioni appena il giocatore termina; stato di attesa per il risultato del gruppo.
- Modulo dati privato dopo il gioco e possibilità esplicita di saltarlo.
- Proiezione delle classifiche individuali e di gruppo della giornata.

Implementazione HEEx/Tailwind, Layouts.app, componenti input e icon del progetto,
AshPhoenix.Form e streams per le liste dinamiche. Accesso da tastiera, focus visibile,
contrasto leggibile, testo alternativo e reduced-motion. Nessun JavaScript inline dei mockup.

## Fasi di consegna e verifiche

1. **Dominio e persistenza**: risorse, azioni, policies, migrazioni, seed idempotente con almeno
   dieci domande e difficoltà distribuite; topic modificabili. Verificare vincoli, punteggi,
   snapshot, letture private e filtro giornaliero.
2. **Identità anonima e amministrazione**: sessioni partecipante/admin, codice di recupero,
   protezione delle rotte e delle azioni. Verificare accessi non autorizzati, rientro e doppie tab.
3. **Lobby e gruppi**: FIFO, formazione automatica, nomi e modifica pre-avvio. Verificare
   ingressi simultanei, quartetti esatti, coda residua e isolamento tra gruppi.
4. **Motore di gioco**: avvio admin, estrazione, durata congelata, risposte, progresso indipendente,
   timeout e finalizzazione. Verificare invii doppi/tardivi, errori DB, disconnessioni e crash.
5. **LiveView giocatore**: ingresso, attese, quiz con immagini, recupero, risultati e modulo.
   Verificare il percorso completo e gli stati in attesa con Phoenix.LiveViewTest.
6. **Admin e immagini**: CRUD domande/topic, upload, tempo, avvio e annullamento. Verificare
   esattamente quattro opzioni, soluzione valida, upload e invariabilità delle partite già avviate.
7. **Classifiche e finitura**: letture top 10, pari merito, PubSub, proiezione e responsive.
   Verificare confini della giornata, risultati incompleti, assenza di dati privati e dieci gruppi in parallelo.

Leggere le skill locali Ash/Phoenix e le usage rules per ogni area implementata.
Eseguire test pertinenti durante le fasi e `mix precommit` al termine delle modifiche applicative.

## Decisioni finali confermate

- Direzione visiva principale: chiara delle pagine separate.
- Denominazione visibile: ITS PROTOCOL.
- Valore iniziale del tempo globale: cinque minuti, modificabili dall'admin.

Il piano è pronto per l'implementazione. I dettagli operativi proposti nel documento
rimangono convenzioni di implementazione; i contenuti dell'informativa e i tempi di
conservazione dei dati personali restano da definire.
