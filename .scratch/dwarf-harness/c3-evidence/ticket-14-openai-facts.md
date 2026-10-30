# OpenAI Responses facts for ticket 14

**Retrieved:** 2026-10-30 09:46:07–10:01:52 EDT. Each external-source citation names the URL read and this retrieval window. Appendix comparison source: `docs/DESIGN-ROUTING-LAYER.md` at cited lines. SAME/CHANGED/GONE counts are Appendix B row counts; NEW and UNVERIFIED are topic groups. No live authenticated API call was made.

## 1. Models

**SAME 3; CHANGED 0; GONE 0; NEW 9; UNVERIFIED 1.**

Appendix B: `| GPT-6 Luna | 1,050,000 | 922,000 | 128,000 |`; `| GPT-6 Sol | 1,050,000 | 922,000 | 128,000 |`; `| GPT-6 Astra | 1,050,000 | 922,000 | 128,000 |` (`docs/DESIGN-ROUTING-LAYER.md:1151-1155`). Current pages for `gpt-6-luna`, `gpt-6-sol`, `gpt-6-astra` report the same context 1,050,000, maximum input 922,000 and maximum output 128,000 tokens. **SAME.** Sources: [Luna](https://developers.openai.com/api/docs/models/gpt-6-luna.md), [Sol](https://developers.openai.com/api/docs/models/gpt-6-sol.md), [Astra](https://developers.openai.com/api/docs/models/gpt-6-astra.md); retrieved during the window above.

The catalog labels these “Featured models”: `gpt-6-astra`, `gpt-6.1-sol`, `gpt-6.1-terra`, `gpt-6-luna`. **NEW:** nine additional model rows checked: `gpt-6.1-sol`, `gpt-6.1-terra`, `gpt-5.6-sol`, `gpt-5.6-terra`, `gpt-5.6-luna`, `gpt-5.5`, `gpt-5.5-pro`, `gpt-5.4`, `gpt-5.4-pro`. The first five report context 1,050,000, max input 922,000 and max output 128,000. `gpt-5.5` and `gpt-5.4` pages report context 1,050,000 and max output 128,000 but do not state max input. Their `-pro` pricing rows exist, but their individual context/input/output limits were not checked. Sources: [catalog](https://developers.openai.com/api/docs/models.md), [6.1 Sol](https://developers.openai.com/api/docs/models/gpt-6.1-sol.md), [6.1 Terra](https://developers.openai.com/api/docs/models/gpt-6.1-terra.md), [5.6 Sol](https://developers.openai.com/api/docs/models/gpt-5.6-sol.md), [5.6 Terra](https://developers.openai.com/api/docs/models/gpt-5.6-terra.md), [5.6 Luna](https://developers.openai.com/api/docs/models/gpt-5.6-luna.md), [5.5](https://developers.openai.com/api/docs/models/gpt-5.5.md), [5.4](https://developers.openai.com/api/docs/models/gpt-5.4.md); retrieved during the window above.

**UNVERIFIED:** exhaustive “every other current Responses text model” set. The catalog does not define a complete “current Responses text models” cohort and includes legacy, preview, specialized, and deprecated models; no authenticated `GET /v1/models` enumeration was made. The listed rows are not claimed exhaustive.

Deprecations page (upcoming): “On October 14, 2026, we notified developers using certain GPT-4 series models of their deprecation and removal from the API on January 14, 2027.” Its table lists GPT-4o snapshots `gpt-4o-2024-08-06`, `gpt-4o-2024-11-20`; GPT-4o mini `gpt-4o-mini-2024-07-18`; GPT-4.1 snapshot `gpt-4.1-2025-04-14`; and GPT-4.1 mini `gpt-4.1-mini-2025-04-14`. It says the Oct. 1 models `gpt-5.3-codex`, `gpt-5.4-nano`/`gpt-5.4-nano-2026-03-17`, and `gpt-5.1`/`gpt-5.1-2025-11-13` “are deprecated and will be removed from the API on April 1, 2027.” The June 11 table additionally lists `gpt-5`/`gpt-5-2025-08-07`, `gpt-5-mini`/`gpt-5-mini-2025-08-07`, `gpt-5-nano`/`gpt-5-nano-2025-08-07`, `gpt-5-pro`/`gpt-5-pro-2025-10-06`, `o3`/`o3-2025-04-16`, and `o3-pro`/`o3-pro-2025-06-10`, with Dec. 11, 2026 shutdown. Source: [deprecations](https://developers.openai.com/api/docs/deprecations.md); retrieved during the window above. The page also documents optional `shutdown_date` in the Models API.

## 2. Prices and modifiers

**SAME 6; CHANGED 0; GONE 0; NEW 3; UNVERIFIED 1.**

Appendix B standard rates, columns input/cached/cache-write/output: “GPT-6 Luna `0.10 / 0.01 / 0.125 / 0.50`; GPT-6 Sol `2 / 0.20 / 2.50 / 10`; GPT-6 Astra `10 / 1 / 12.50 / 50`.” Long rows: Luna `0.20 / 0.02 / 0.25 / 0.75`; Sol `4 / 0.40 / 5 / 15`; Astra `20 / 2 / 25 / 75`. `docs/DESIGN-ROUTING-LAYER.md:1157-1165`. Current pricing table matches all six rows. It says: “The 272K threshold is based on input tokens. Requests above the threshold are charged at long-context rates for the entire request.” **SAME** on rates/threshold. **NEW:** 12-hour cache-write rates and additional model/tier/fee facts.

Current standard prices, USD per million; each side lists input / cached input / 30-minute write / 12-hour write / output. Long context is `>272K` input tokens:

| Model | Short context | Long context |
|---|---|---|
| `gpt-6-astra` | 10 / 1 / 12.50 / 25 / 50 | 20 / 2 / 25 / 50 / 75 |
| `gpt-6.1-sol` | 2 / 0.10 / 2.50 / 5 / 10 | 4 / 0.20 / 5 / 10 / 15 |
| `gpt-6.1-terra` | 1 / 0.05 / 1.25 / 2.50 / 5 | 2 / 0.10 / 2.50 / 5 / 7.50 |
| `gpt-6-luna` | 0.10 / 0.01 / 0.125 / 0.25 / 0.50 | 0.20 / 0.02 / 0.25 / 0.50 / 0.75 |
| `gpt-6-sol` | 2 / 0.20 / 2.50 / 5 / 10 | 4 / 0.40 / 5 / 10 / 15 |
| `gpt-5.6-sol` | 4 / 0.40 / 5 / 10 / 20 | 8 / 0.80 / 10 / 20 / 30 |
| `gpt-5.6-terra` | 2 / 0.20 / 2.50 / 5 / 12 | 4 / 0.40 / 5 / 10 / 18 |
| `gpt-5.6-luna` | 0.20 / 0.02 / 0.25 / 0.50 / 1.20 | 0.40 / 0.04 / 0.50 / 1 / 1.80 |
| `gpt-5.5` | 5 / 0.50 / — / — / 30 | 10 / 1 / — / — / 45 |
| `gpt-5.5-pro` | 30 / — / — / — / 180 | 60 / — / — / — / 270 |
| `gpt-5.4` | 2.50 / 0.25 / — / — / 15 | 5 / 0.50 / — / — / 22.50 |
| `gpt-5.4-pro` | 30 / — / — / — / 180 | 60 / — / — / — / 270 |

Source: [pricing](https://developers.openai.com/api/docs/pricing.md); retrieved during the window above. Dashes mean no rate shown in the corresponding table cell, not zero. The page states the long rates apply to the whole request and cover input, cached input, writes and output.

Regional pricing quote: “Regional processing (data residency) endpoints are charged a 10% uplift for models released on or after March 5, 2026. FedRAMP endpoints are also charged a 10% uplift.” The regional uplift is further limited to models eligible for data residency. The Your data table is endpoint/tier-specific; it lists GPT-6 and GPT-5.6 models, and `gpt-6.1-sol` and `gpt-6.1-terra` for US/EU. Sources: [pricing](https://developers.openai.com/api/docs/pricing.md), [Your data](https://developers.openai.com/api/docs/guides/your-data.md); retrieved during the window above. **UNVERIFIED:** complete region/uplift matrix for all candidate current models because model-cohort scope is unresolved and region support varies by endpoint/tier.

Tiers: Batch/Flex pricing tables give half-standard token rates for their listed models. Flex guide: “Flex Processing uses Batch API pricing”; Flex is limited-model beta. Fast pricing lists 2× standard for supported models; the guide reports up to 2.5× speed for GPT-5.6 Sol. Ultrafast pricing lists 6× Standard for GPT-6 Astra and GPT-6.1 Sol. Sources: [pricing](https://developers.openai.com/api/docs/pricing.md), [Flex](https://developers.openai.com/api/docs/guides/flex-processing.md), [Fast](https://developers.openai.com/api/docs/guides/fast-mode.md), [Ultrafast](https://developers.openai.com/api/docs/guides/ultrafast-mode.md); retrieved during the window above.

Per-request hosted-tool fees: web search `$10.00 / 1k calls` plus search-content tokens at model rates; preview web search on non-reasoning models `$25.00 / 1k calls` with search-content tokens free; file-search storage `$0.10 / GB per day (1 GB free)`, tool calls `$2.50 / 1k calls`; hosted Shell/Code Interpreter: `$0.03` (1 GB), `$0.12` (4 GB), `$0.48` (16 GB), `$1.92` (64 GB) “per 20-minute session per container.” Pricing page: “Tokens used for built-in tools are billed at the chosen model's per-token rates.” Source: [pricing](https://developers.openai.com/api/docs/pricing.md); retrieved during the window above. No separate caller-defined-function call fee is listed.

Tier discrepancy: current Ultrafast guide and Oct. 8 changelog identify GPT-6 Astra and GPT-6.1 Sol; create reference says Ultrafast “is currently available for `gpt-5.6-sol`.” Sources: [create reference](https://developers.openai.com/api/reference/resources/responses/methods/create), [Ultrafast](https://developers.openai.com/api/docs/guides/ultrafast-mode.md), [changelog](https://developers.openai.com/api/docs/changelog.md); retrieved during the window above.

## 3. Tool-definition token overhead

**SAME 0; CHANGED 0; GONE 0; NEW 1; UNVERIFIED 1.**

Token counting guide: “Tools and schemas add tokens that are hard to count locally.” It says the token-count endpoint “returns the exact number of tokens that would be sent to the model.” Source: [token counting](https://developers.openai.com/api/docs/guides/token-counting.md); retrieved during the window above. **UNVERIFIED:** no fixed overhead number per function/tool/schema is published in the checked docs; only request-specific token counting is documented.

## 4. `POST /v1/responses` request

**SAME 0; CHANGED 0; GONE 0; NEW 1; UNVERIFIED 3.**

Route: create reference `POST /responses`, base URL example `https://api.openai.com/v1/responses`. Headers: `Authorization: Bearer …`; `Content-Type: application/json`; optional `OpenAI-Organization` and `OpenAI-Project` to select organization/project. Sources: [create](https://developers.openai.com/api/reference/resources/responses/methods/create), [API overview](https://developers.openai.com/api/reference/overview); retrieved during the window above.

Request schema facts:
- `model`: reference marks `optional ResponsesModel`, although examples supply it. **UNVERIFIED:** omission behavior/default; the schema declaration and examples do not resolve this.
- `input`: optional string or item/message list; no general string/token maximum stated in create schema.
- `instructions`: optional string/null; with `previous_response_id`, “the instructions from a previous response will not be carried over to the next response.”
- `max_output_tokens`: optional integer, minimum 16; upper bound includes visible and reasoning tokens.
- `stream`: optional boolean, default false; true streams SSE.
- `tools`: optional array. Function fields include `name`, `parameters` JSON schema/null, `strict`, `type`, optional `description`, `allowed_callers`, `async`, `defer_loading`, `output_schema`; no function count/name/description length limit stated.
- `tool_choice`: `none`, `auto`, `required`; also an `allowed_tools` object with mode `auto` or `required`, forced function/builtin/custom/MCP selections.
- `parallel_tool_calls`: optional boolean, default true.
- `reasoning`: optional object; `effort` values include `none`, `minimal`, `low`, `medium`, `high`, `xhigh`, `max` (model-specific); `summary` includes `auto`, `concise`, `detailed`; `mode` `standard` or `pro`; `context` `auto`, `current_turn`, `all_turns`. Schema marks `generate_summary` deprecated. Reasoning guide says GPT-6.1 Sol defaults medium and does not support none/minimal; Astra rejects none.
- `text`: optional config. `format` default `{ "type": "text" }`, also JSON Schema and legacy `json_object`; `verbosity` low/medium/high, default medium.
- `temperature`: optional number, range 0–2, default 1. `top_p`: optional number, range 0–1, default 1. GPT-6 Astra does not support custom temperature/top_p.
- `store`: optional boolean, default true; if true response data is stored “for at least 30 days,” subject to data-retention exceptions.
- `metadata`: up to 16 key/value pairs; key max 64 characters, value max 512.
- `service_tier`: `auto`, `default`, `flex`, `scale`, `priority`, `fast`, `ultrafast`; default `auto`. See item 7.
- `prompt_cache_key`: optional string; no length limit stated. `prompt_cache_retention` is deprecated; legacy values `in_memory` and `24h`. New `prompt_cache_options` exposes mode/prewarm/TTL; create schema says `30m` TTL, while guide/changelog document `12h`. **UNVERIFIED:** current create-schema acceptance of `12h`, due this conflict.
- `truncation`: `disabled` default or `auto`; auto drops input items from the beginning to fit context. Disabled returns HTTP 400 if input size exceeds model context.
- `include`: enum includes `web_search_call.action.sources`, `code_interpreter_call.outputs`, `computer_call_output.output.image_url`, `file_search_call.results`, `message.input_image.image_url`, `message.output_text.logprobs`, `reasoning.encrypted_content`.
- `previous_response_id`: optional; cannot be combined with a Conversation parameter. Prior instructions do not carry forward.
- `context_management`: optional array, minimum one action; compaction action has `compact_threshold`, integer minimum 1,000.
- `background`: optional boolean, default false; true runs asynchronously.

Sources: [create](https://developers.openai.com/api/reference/resources/responses/methods/create), [reasoning](https://developers.openai.com/api/docs/guides/reasoning.md), [background](https://developers.openai.com/api/docs/guides/background.md), [prompt caching](https://developers.openai.com/api/docs/guides/prompt-caching.md); retrieved during the window above.

**UNVERIFIED — combined context fit.** Docs state context and maximum input/output separately. `auto` drops input items to fit context; `disabled` returns 400 if input size exceeds context. No per-model rule was found for an input within its input maximum where input plus requested `max_output_tokens` exceeds context.

## 5. Streaming

**SAME 0; CHANGED 0; GONE 0; NEW 1; UNVERIFIED 2.**

Text/function event types documented: `response.created`, `response.in_progress`, `response.queued`, `response.output_item.added`, `response.content_part.added`, `response.output_text.delta`, `response.output_text.done`, `response.output_text.annotation.added`, `response.content_part.done`, `response.output_item.done`, `response.reasoning_summary_part.added`, `response.reasoning_summary_part.done`, `response.reasoning_summary_text.delta`, `response.reasoning_summary_text.done`, `response.reasoning_text.delta`, `response.reasoning_text.done`, `response.refusal.delta`, `response.refusal.done`, `response.function_call_arguments.delta`, `response.function_call_arguments.done`, `response.compaction.compacting`, `response.completed`, `response.incomplete`, `response.failed`, and `error`. The larger catalogue additionally has hosted search, code interpreter, image/audio, MCP, shell, and other tool-specific events; these are outside the text/function-only request scope. Sources: [streaming guide](https://developers.openai.com/api/docs/guides/streaming-responses.md), [event reference](https://developers.openai.com/api/reference/resources/responses/streaming-events); retrieved during the window above.

**Order.** Create example shows `response.created` (sequence 0), `response.in_progress` (1), `response.output_item.added` (2), `response.content_part.added` (3), `response.output_text.delta` (4), then (intermediate events omitted) `response.output_text.done` (10), `response.content_part.done` (11), `response.output_item.done` (12), `response.completed` (13). It does not state a universal order for all event types/interleavings. **UNVERIFIED:** normative ordering beyond the example.

`sequence_number` description: “The sequence number of this event, used to order streaming events.” `response.created`, `response.in_progress`, `response.queued`, `response.completed`, `response.incomplete`, `response.failed` carry a `response` object; item/content/delta events have event fields. Usage appears in `response.usage` on the completed response; in-progress example has null usage. The schema does not state a cumulative-snapshot guarantee. **UNVERIFIED:** formal guarantee that every lifecycle response is cumulative. Source: [event reference](https://developers.openai.com/api/reference/resources/responses/streaming-events); retrieved during the window above.

Verbatim `data` examples from the event reference:

```json
{"type":"response.created","response":{"id":"resp_67ccfcdd16748190a91872c75d38539e09e4d4aac714747c","object":"response","access_programs":null,"created_at":1741487325,"status":"in_progress","completed_at":null,"error":null,"incomplete_details":null,"instructions":null,"max_output_tokens":null,"model":"gpt-6-astra","output":[],"parallel_tool_calls":true,"previous_response_id":null,"reasoning":{"effort":null,"summary":null},"store":true,"temperature":1,"text":{"format":{"type":"text"}},"tool_choice":"auto","tools":[],"top_p":1,"truncation":"disabled","usage":null,"user":null,"metadata":{}},"sequence_number":1}
```
```json
{"type":"response.in_progress","response":{"id":"resp_67ccfcdd16748190a91872c75d38539e09e4d4aac714747c","object":"response","access_programs":null,"created_at":1741487325,"status":"in_progress","completed_at":null,"error":null,"incomplete_details":null,"instructions":null,"max_output_tokens":null,"model":"gpt-6-astra","output":[],"parallel_tool_calls":true,"previous_response_id":null,"reasoning":{"effort":null,"summary":null},"store":true,"temperature":1,"text":{"format":{"type":"text"}},"tool_choice":"auto","tools":[],"top_p":1,"truncation":"disabled","usage":null,"user":null,"metadata":{}},"sequence_number":1}
```
```json
{"type":"response.queued","response":{"id":"resp_123","object":"response","access_programs":null,"created_at":1609459200,"status":"queued","error":null,"incomplete_details":null,"instructions":null,"model":"gpt-6-astra","output":[],"parallel_tool_calls":true,"temperature":1,"tool_choice":"auto","tools":[],"top_p":1,"metadata":{}},"sequence_number":1}
```
```json
{"type":"response.output_item.added","output_index":0,"item":{"id":"msg_123","status":"in_progress","type":"message","role":"assistant","content":[]},"sequence_number":1}
```
```json
{"type":"response.content_part.added","item_id":"msg_123","output_index":0,"content_index":0,"part":{"type":"output_text","text":"","annotations":[],"logprobs":[]},"sequence_number":1}
```
```json
{"type":"response.output_text.delta","item_id":"msg_123","output_index":0,"content_index":0,"delta":"In","sequence_number":1,"logprobs":[]}
```
```json
{"type":"response.output_text.done","item_id":"msg_123","output_index":0,"content_index":0,"text":"In a shimmering forest under a sky full of stars, a lonely unicorn named Lila discovered a hidden pond that glowed with moonlight. Every night, she would leave sparkling, magical flowers by the water's edge, hoping to share her beauty with others. One enchanting evening, she woke to find a group of friendly animals gathered around, eager to be friends and share in her magic.","sequence_number":1,"logprobs":[]}
```
```json
{"type":"response.output_text.annotation.added","item_id":"item-abc","output_index":0,"content_index":0,"annotation_index":0,"annotation":{"type":"file_citation","file_id":"file-abc","index":0,"filename":"example.txt"},"sequence_number":1}
```
```json
{"type":"response.content_part.done","item_id":"msg_123","output_index":0,"content_index":0,"sequence_number":1,"part":{"type":"output_text","text":"In a shimmering forest under a sky full of stars, a lonely unicorn named Lila discovered a hidden pond that glowed with moonlight. Every night, she would leave sparkling, magical flowers by the water's edge, hoping to share her beauty with others. One enchanting evening, she woke to find a group of friendly animals gathered around, eager to be friends and share in her magic.","annotations":[],"logprobs":[]}}
```
```json
{"type":"response.output_item.done","output_index":0,"item":{"id":"msg_123","status":"completed","type":"message","role":"assistant","content":[{"type":"output_text","text":"In a shimmering forest under a sky full of stars, a lonely unicorn named Lila discovered a hidden pond that glowed with moonlight. Every night, she would leave sparkling, magical flowers by the water's edge, hoping to share her beauty with others. One enchanting evening, she woke to find a group of friendly animals gathered around, eager to be friends and share in her magic.","annotations":[],"logprobs":[]}]},"sequence_number":1}
```
```json
{"type":"response.refusal.delta","item_id":"msg_123","output_index":0,"content_index":0,"delta":"refusal text so far","sequence_number":1}
```
```json
{"type":"response.refusal.done","item_id":"item-abc","output_index":1,"content_index":2,"refusal":"final refusal text","sequence_number":1}
```
```json
{"type":"response.function_call_arguments.delta","item_id":"item-abc","output_index":0,"delta":"{ \"arg\":","sequence_number":1}
```
```json
{"type":"response.function_call_arguments.done","item_id":"item-abc","output_index":1,"arguments":"{ \"arg\": 123 }","sequence_number":1}
```
```json
{"type":"response.reasoning_text.delta","item_id":"rs_123","output_index":0,"content_index":0,"delta":"The","sequence_number":1}
```
```json
{"type":"response.reasoning_text.done","item_id":"rs_123","output_index":0,"content_index":0,"text":"The user is asking...","sequence_number":4}
```
```json
{"type":"response.reasoning_summary_part.added","item_id":"rs_6806bfca0b2481918a5748308061a2600d3ce51bdffd5476","output_index":0,"summary_index":0,"part":{"type":"summary_text","text":""},"sequence_number":1}
```
```json
{"type":"response.reasoning_summary_part.done","item_id":"rs_6806bfca0b2481918a5748308061a2600d3ce51bdffd5476","output_index":0,"summary_index":0,"part":{"type":"summary_text","text":"**Responding to a greeting**\n\nThe user just said, \"Hello!\" So, it seems I need to engage. I'll greet them back and offer help since they're looking to chat. I could say something like, \"Hello! How can I assist you today?\" That feels friendly and open. They didn't ask a specific question, so this approach will work well for starting a conversation. Let's see where it goes from there!"},"sequence_number":1}
```
```json
{"type":"response.reasoning_summary_text.delta","item_id":"rs_6806bfca0b2481918a5748308061a2600d3ce51bdffd5476","output_index":0,"summary_index":0,"delta":"**Responding to a greeting**\n\nThe user just said, \"Hello!\" So, it seems I need to engage. I'll greet them back and offer help since they're looking to chat. I could say something like, \"Hello! How can I assist you today?\" That feels friendly and open. They didn't ask a specific question, so this approach will work well for starting a conversation. Let's see where it goes from there!","sequence_number":1}
```
```json
{"type":"response.reasoning_summary_text.done","item_id":"rs_6806bfca0b2481918a5748308061a2600d3ce51bdffd5476","output_index":0,"summary_index":0,"text":"**Responding to a greeting**\n\nThe user just said, \"Hello!\" So, it seems I need to engage. I'll greet them back and offer help since they're looking to chat. I could say something like, \"Hello! How can I assist you today?\" That feels friendly and open. They didn't ask a specific question, so this approach will work well for starting a conversation. Let's see where it goes from there!","sequence_number":1}
```
```json
{"type":"response.compaction.compacting","sequence_number":0,"output_index":0,"item_id":"item_id"}
```
```json
{"type":"response.completed","response":{"id":"resp_123","object":"response","access_programs":null,"created_at":1740855869,"status":"completed","completed_at":1740855870,"error":null,"incomplete_details":null,"input":[],"instructions":null,"max_output_tokens":null,"model":"gpt-6-astra","output":[{"id":"msg_123","type":"message","role":"assistant","content":[{"type":"output_text","text":"In a shimmering forest under a sky full of stars, a lonely unicorn named Lila discovered a hidden pond that glowed with moonlight. Every night, she would leave sparkling, magical flowers by the water's edge, hoping to share her beauty with others. One enchanting evening, she woke to find a group of friendly animals gathered around, eager to be friends and share in her magic.","annotations":[],"logprobs":[]}],"status":"completed"}],"previous_response_id":null,"reasoning_effort":null,"store":false,"temperature":1,"text":{"format":{"type":"text"}},"tool_choice":"auto","tools":[],"top_p":1,"truncation":"disabled","usage":{"input_tokens":0,"output_tokens":0,"output_tokens_details":{"reasoning_tokens":0},"total_tokens":0,"input_tokens_details":{"cached_tokens":0,"cache_write_tokens":0}},"user":null,"metadata":{},"parallel_tool_calls":true},"sequence_number":1}
```
```json
{"type":"response.incomplete","response":{"id":"resp_123","object":"response","access_programs":null,"created_at":1740855869,"status":"incomplete","completed_at":null,"error":null,"incomplete_details":{"reason":"max_output_tokens"},"instructions":null,"max_output_tokens":null,"model":"gpt-6-astra","output":[],"previous_response_id":null,"reasoning_effort":null,"store":false,"temperature":1,"text":{"format":{"type":"text"}},"tool_choice":"auto","tools":[],"top_p":1,"truncation":"disabled","usage":null,"user":null,"metadata":{},"parallel_tool_calls":true},"sequence_number":1}
```
```json
{"type":"response.failed","response":{"id":"resp_123","object":"response","access_programs":null,"created_at":1740855869,"status":"failed","completed_at":null,"error":{"code":"server_error","message":"The model failed to generate a response."},"incomplete_details":null,"instructions":null,"max_output_tokens":null,"model":"gpt-6-astra","output":[],"previous_response_id":null,"reasoning_effort":null,"store":false,"temperature":1,"text":{"format":{"type":"text"}},"tool_choice":"auto","tools":[],"top_p":1,"truncation":"disabled","usage":null,"user":null,"metadata":{},"parallel_tool_calls":true},"sequence_number":1}
```
```json
{"type":"error","code":"ERR_SOMETHING","message":"Something went wrong","param":null,"sequence_number":1}
```

Sources for examples/order: [streaming events](https://developers.openai.com/api/reference/resources/responses/streaming-events), [Responses create](https://developers.openai.com/api/reference/resources/responses/methods/create); retrieved during the window above. **UNVERIFIED:** API overview says adding event types is backward compatible, but does not state what a client MUST do on unknown event types.

## 6. Usage

**SAME 0; CHANGED 0; GONE 0; NEW 1; UNVERIFIED 1.**

Response fields: `usage.input_tokens`; `input_tokens_details.cached_tokens`; `input_tokens_details.cache_write_tokens`; `output_tokens`; `output_tokens_details.reasoning_tokens`; `total_tokens`; and separate `tool_usage` details such as `web_search.num_requests` and image-generation usage. Source: [Response object](https://developers.openai.com/api/reference/resources/responses); retrieved during the window above. Completed example includes usage in `response.usage`; in-progress example has null.

Reasoning guide says reasoning tokens count as output tokens; `output_tokens_details.reasoning_tokens` is a detail within output. Cached reads/writes are detailed within input. `total_tokens` is input plus output. Hosted tool requests are separately represented in `tool_usage`. Sources: [reasoning](https://developers.openai.com/api/docs/guides/reasoning.md), [prompt caching](https://developers.openai.com/api/docs/guides/prompt-caching.md), [Response object](https://developers.openai.com/api/reference/resources/responses); retrieved during the window above.

**UNVERIFIED:** per-TTL write breakdown (`30m` vs `12h`) in usage; checked Response schema exposes generic `cache_write_tokens`, not a TTL-specific field.

## 7. Service tiers

**SAME 0; CHANGED 0; GONE 0; NEW 1; UNVERIFIED 1.**

Create schema values `auto`, `default`, `flex`, `scale`, `priority`, `fast`, `ultrafast`; default `auto`. It says: “If set to 'auto', then the request will be processed with the service tier configured in the Project settings. Unless otherwise configured, the Project will use 'default'.” `default` is standard price/performance; `flex` Flex Processing; `fast`/`priority` Fast; `ultrafast` access-controlled. The response reports actual served `service_tier`, which “may be different from the value set in the parameter.” Fast request uses response `priority`; downgrade to standard is reported `default`. Project settings select tier defaults; organization settings can restrict allowed tiers. Sources: [create](https://developers.openai.com/api/reference/resources/responses/methods/create), [Fast](https://developers.openai.com/api/docs/guides/fast-mode.md), [changelog](https://developers.openai.com/api/docs/changelog.md); retrieved during the window above. **UNVERIFIED:** `scale` service/model scope and price; enum is present but current behavior is not documented in checked sources.

## 8. Status, refusal, incomplete reasoning

**SAME 2; CHANGED 0; GONE 0; NEW 1; UNVERIFIED 0.**

Status values: `completed`, `failed`, `in_progress`, `cancelled`, `queued`, `incomplete`. Incomplete reasons: `max_output_tokens`, `max_messages`, `content_filter`, `steered` (`steered` is WebSocket-specific). Refusal is output content type `refusal`, streamed via `response.refusal.delta` and `.done` (examples in item 5). Source: [Response object](https://developers.openai.com/api/reference/resources/responses); retrieved during the window above.

Reasoning guide: “If the model reaches the `max_output_tokens` limit while generating reasoning tokens, the response returns `status: "incomplete"` with `incomplete_details.reason: "max_output_tokens"`.” It states input and reasoning tokens are billed even with no visible answer. This matches Appendix B's text/reasoning shared output cap and possible input/reasoning charge. Appendix: `docs/DESIGN-ROUTING-LAYER.md:1197-1217`; source: [reasoning](https://developers.openai.com/api/docs/guides/reasoning.md); retrieved during the window above.

## 9. Response headers

**SAME 0; CHANGED 0; GONE 0; NEW 1; UNVERIFIED 0.**

API overview response headers: `x-request-id`, `openai-organization`, `openai-processing-ms`, `openai-version` (example `2020-10-01`). Rate-limit headers: `x-ratelimit-limit-requests`, `x-ratelimit-remaining-requests`, `x-ratelimit-reset-requests`, corresponding `-tokens` names and project-token limit/remaining/reset. `Retry-After` is seconds when present; reset examples include `1s`, `6m0s`. Sources: [API overview](https://developers.openai.com/api/reference/overview), [rate limits](https://developers.openai.com/api/docs/guides/rate-limits.md); retrieved during the window above.

## 10. Errors and long requests

**SAME 1; CHANGED 0; GONE 0; NEW 1; UNVERIFIED 2.**

Appendix B records 429 quota/spend codes and 503 overload (`docs/DESIGN-ROUTING-LAYER.md:1197-1217`); these are retained. Current error guide mappings: 400 invalid `service_tier` is `invalid_request_error`; 401 invalid authentication/incorrect key (guide table does not supply an API `error.type` or code); 403 unsupported country/region (table does not supply `error.type`/code); 429 prepaid-credit code `credit_balance_exhausted`; rate-limit request entry has no fixed type/code; `slow_down` has type `rate_limit_error`; spend codes `organization_spend_limit_exceeded` and `project_spend_limit_exceeded`; usage code `organization_usage_limit_exceeded`. The guide says broader billing `error.type` can be `insufficient_quota`. HTTP 500 server error (table does not supply `error.type`/code); HTTP 503 type `service_unavailable_error`, code `server_is_overloaded`. Retrying billing/spend/quota errors “won't restore API access.” Sources: [error codes](https://developers.openai.com/api/docs/guides/error-codes.md), [rate limits](https://developers.openai.com/api/docs/guides/rate-limits.md); retrieved during the window above.

Flex guide discusses 408 and 10-minute default SDK timeout, with 15-minute example; background guide describes async polling; Java SDK says default request timeout 10 minutes. **UNVERIFIED:** Responses server-side maximum duration and authoritative 408/504 API error mapping; docs/SDKs do not provide a single such mapping. Sources: [Flex](https://developers.openai.com/api/docs/guides/flex-processing.md), [background](https://developers.openai.com/api/docs/guides/background.md), [Java SDK](https://github.com/openai/openai-java); retrieved during the window above.

## 11. Billing partial/failed/cancelled/disconnected

**SAME 0; CHANGED 0; GONE 0; NEW 1; UNVERIFIED 1.**

Max-output-incomplete reasoning case bills input and reasoning (item 8). API schema has `cancelled`; background guide documents cancellation. Completed stream has final usage; failed/incomplete examples can show `usage: null`. Rate-limit guide's “unsuccessful calls count towards your rate limit” concerns rate limits, not token billing. Sources: [reasoning](https://developers.openai.com/api/docs/guides/reasoning.md), [background](https://developers.openai.com/api/docs/guides/background.md), [rate limits](https://developers.openai.com/api/docs/guides/rate-limits.md), [Response object](https://developers.openai.com/api/reference/resources/responses); retrieved during the window above.

**UNVERIFIED:** billing for partial visible output, failed requests, explicit cancellation, client disconnect, or a stream disconnected before terminal usage arrives. No general billing rule was found; `usage: null` examples do not prove no charge.

## 12. Retries and idempotency

**SAME 0; CHANGED 0; GONE 0; NEW 1; UNVERIFIED 1.**

Official SDK docs: JavaScript/TypeScript, Python and Go each say two default retries for connection errors, 408, 409, 429 and >=500; Java says two for connection errors, 408, 409, 429, 5xx; Ruby says two for replayable requests, with 408, 409, 429, >=500 and ambiguous network/timeouts retried only under its no-bytes-sent/idempotent-method/nonempty-`Idempotency-Key` conditions. .NET says “up to three additional times” for 408, 429, 500, 502, 503, 504. Sources: [Node](https://github.com/openai/openai-node), [Python](https://github.com/openai/openai-python), [Go](https://github.com/openai/openai-go), [Java](https://github.com/openai/openai-java), [Ruby](https://github.com/openai/openai-ruby), [.NET](https://github.com/openai/openai-dotnet), [SDK list](https://developers.openai.com/api/docs/libraries.md); retrieved during the window above.

**UNVERIFIED:** API-level idempotency/deduplication contract for `POST /v1/responses` (key, scope, retention/replay behavior). Ruby SDK describes a nonempty `Idempotency-Key` as a condition for retrying ambiguous requests and scoped keys in its tool-runner; this does not document Responses server dedup. API overview's `X-Client-Request-Id` is correlation, not a dedup promise. Sources: [Ruby SDK](https://github.com/openai/openai-ruby), [API overview](https://developers.openai.com/api/reference/overview); retrieved during the window above.

## 13. Prompt caching

**SAME 4; CHANGED 0; GONE 0; NEW 3; UNVERIFIED 1.**

Appendix B: GPT-5.6+ write 1.25×/read 0.1×, minimum 1,024, implicit/explicit breakpoints, max four writes, >=30-minute TTL and prewarm; earlier `prompt_cache_key` routing around 15 requests/minute/key and retention `in_memory`/`24h`; caches not shared across org/region (`docs/DESIGN-ROUTING-LAYER.md:1197-1217`). Current guide: caching enabled by default for supported models; GPT-5.6+ minimum 1,024; implicit/explicit modes; max four writes; `prompt_cache_key` is routing, not a guaranteed pin; caches not shared across orgs/regional boundaries. Default write 1.25× and read generally 0.1×; GPT-6.1 Sol/Terra reads 0.05×. 12-hour writes cost 2.5×. Writes/reads use input/cache-write and cached-input rates respectively. Sources: [prompt caching](https://developers.openai.com/api/docs/guides/prompt-caching.md), [pricing](https://developers.openai.com/api/docs/pricing.md); retrieved during the window above. **SAME** applicable Appendix values; **NEW** 12-hour TTL/pricing and 0.05× cached-read models.

**UNVERIFIED:** create schema `prompt_cache_options.ttl` says `30m`, while guide and Oct. 20 changelog document `12h`; direct source conflict. Legacy deprecated `prompt_cache_retention` values `in_memory`/`24h` are distinct.

## 14. Data controls and `store`

**SAME 0; CHANGED 0; GONE 0; NEW 1; UNVERIFIED 0.**

Create schema: `store` defaults true; true response data stored “for at least 30 days,” subject to exceptions. Your data guide: Responses app state default 30 days; ZDR treats store as false; abuse-monitoring logs up to 30 days by default. Background responses held on disk about 10 minutes for polling; under Modified Abuse Monitoring, kept after polling only if `store: true` explicitly. Prompt-cache KV data is encrypted and may remain on GPU-local storage up to 24 hours. Sources: [create](https://developers.openai.com/api/reference/resources/responses/methods/create), [Your data](https://developers.openai.com/api/docs/guides/your-data.md); retrieved during the window above.

## 15. Keyed Models endpoint

**SAME 0; CHANGED 0; GONE 0; NEW 1; UNVERIFIED 1.**

Reference endpoint `GET /models/{model}` (`/v1/models/{model}`); Model object fields `id`, `created`, `object`, `owned_by`, optional `shutdown_date`. It has no context-window, max-input, or max-output fields. Sources: [retrieve model](https://developers.openai.com/api/reference/resources/models/methods/retrieve), [deprecations](https://developers.openai.com/api/docs/deprecations.md); retrieved during the window above.

**UNVERIFIED:** actual live keyed response values; no API-key request was made.

## 16. Changelog since 2026-10-05

**SAME 0; CHANGED 0; GONE 0; NEW 7; UNVERIFIED 0.**

Relevant entries, quoted excerpts:
- **Oct 5:** “Added an in-product flow for HIPAA compliance support in API Organization settings > General. Admins of eligible organizations can now accept the standard Business Associate Agreement (BAA) and enable HIPAA compliance support for their organization.” (data controls)
- **Oct 6:** “Simplified API usage tiers from five to three: Build, Launch, and Grow. Organizations automatically upgrade as total credit purchases reach tier minimums.” (usage/rate tiers)
- **Oct 8:** “Added Ultrafast mode for GPT-6.1 Sol in the Responses API. Use `gpt-6.1-sol` with `service_tier: "ultrafast"` … available to all API users, subject to rate limits, with global processing and US and EU data residency.” (model/tier/pricing)
- **Oct 20:** “You can now choose 12-hour prompt caching in the API. 12-hour prompt caching keeps shared instructions, tools, and context cached longer … 12-hour cache writes cost 2.5x the input token price.”
- **Oct 21:** “You can now choose which service tiers projects can use in Platform settings. Organization settings can restrict service tiers for all projects.”
- **Oct 26:** `gpt-6.1-terra`, `v1/responses`: “Released GPT-6.1 Terra, a fast, efficient model for visual reasoning, precise computer use, and clear, natural writing.”
- **Oct 28:** “Eligible ChatGPT Pro and Business subscribers can now claim up to $500 per month in free API credits as a subscription benefit.” (credits, not a changed per-token rate)

Source: [API changelog](https://developers.openai.com/api/docs/changelog.md); retrieved during the window above. Oct. 22 Decisions API uses `v1/decisions`, not Responses; Oct. 7 `chat-latest` and Oct. 9/16 Agents entries do not change the scoped Responses text endpoint.

## Open and unverified

1. **Item 1:** exhaustive current Responses text-model set and missing model-page limits; catalog does not define the cohort, and no authenticated model listing was queried.
2. **Item 2:** complete eligible-model × region uplift table; model cohort unresolved and residency is endpoint/tier-specific. Create-reference Ultrafast availability conflicts with current guide/changelog. `scale` behavior/pricing is not documented.
3. **Item 3:** fixed tool/function token overhead is not published.
4. **Item 4:** `model` omission/default; whether `12h` is accepted by create-schema `prompt_cache_options.ttl`; per-model input-plus-output context overflow behavior are unspecified/conflicting.
5. **Item 5:** universal interleaved-event ordering, formal cumulative-snapshot guarantee, and required unknown-event client behavior are not specified.
6. **Item 6:** cache-write usage split by TTL; schema exposes only generic cache-write tokens.
7. **Item 7:** `scale` service/model scope and price.
8. **Item 10:** server-side maximum request duration and authoritative 408/504 mapping; for 401/403/500 and rate-limit 429, the checked API table does not give an `error.type`/`code` for every row.
9. **Item 11:** billing for partial visible output, failures, cancellations and disconnects; no general rule found.
10. **Item 12:** Responses server-side idempotency/dedup contract.
11. **Item 15:** live model endpoint response values; no authenticated call made.

## Supplement 1 — prompt cache options, API wire shapes, and price-threshold wording

**Retrieved:** 2026-10-30 10:08:48 EDT. Scope: the follow-up on prompt-cache schema, text/function/reasoning wire shapes, and the long-context threshold wording.

### (a) `prompt_cache_options`

The create reference declares:

> `prompt_cache_options: optional object { comparison_response_id, mode, prewarm, ttl }`
>
> `comparison_response_id: optional string or null`
>
> `mode: optional "implicit" or "explicit"`
>
> `prewarm: optional boolean`
>
> `ttl: optional "30m"`

It says the options are supported for `gpt-5.6` and later. The object-level description says the `ttl` defaults to `30m`, currently its only supported value. `comparison_response_id` requests cache diagnostics when the feature is enabled. `mode` defaults to `implicit`; `implicit` permits one implicit and up to three explicit breakpoints, while `explicit` disables the implicit breakpoint and permits up to four explicit breakpoints. With `explicit` and no explicit breakpoints, the request does not use prompt caching. `prewarm` prepares the cache without generating output; it defaults to `false`, and `true` overrides `generate` to `false`. The `ttl` is the minimum lifetime for every implicit and explicit breakpoint written by the request; the backend may retain entries longer.

Thus an explicitly selected 30-minute minimum is `prompt_cache_options: {"ttl":"30m"}`. Omitting `mode` retains its documented `implicit` default; omitting `prewarm` leaves prewarming disabled by its documented `false` default. The full request-reference description and all four field definitions are quoted above. Source: [Responses create reference](https://developers.openai.com/api/reference/resources/responses/methods/create); retrieved 2026-10-30 10:08:48 EDT.

### (b) API reference wire shapes

**Input text messages.** The reference says `EasyInputMessage object { content, role, phase, type }`; its `content` is `string or ResponseInputMessageContentList`, its `role` can be `"user"`, `"assistant"`, `"system"`, or `"developer"`, and its `type` is optionally `"message"` (always set to `message`). A content-list text part is `ResponseInputText object { text, type, prompt_cache_breakpoint }`, with `text: string` and `type: "input_text"` (always `input_text`). Therefore both a user text message and an assistant text input use a message item with that input-text part; the role distinguishes the two.

For clarity, the returned assistant text item is separately declared as `ResponseOutputMessage object { id, content, role, 3 more }`: its `role` is `"assistant"`, its message `type` is `"message"`, and its content text part is `ResponseOutputText object { annotations, logprobs, text, type }`, with `type: "output_text"`. The input text part type (`input_text`) and returned output text part type (`output_text`) are distinct.

**Function tool definition.** The request schema declares `Function object { name, parameters, strict, 6 more }` and these fields:

> `name: string`
>
> `description: optional string or null`
>
> `parameters: map[unknown] or null`
>
> `strict: boolean or null`
>
> `type: "function" (default: "function")`

`parameters` is a JSON Schema object; `strict` controls strict parameter validation. Source for message and function schemas: [Responses create reference](https://developers.openai.com/api/reference/resources/responses/methods/create); [Responses reference](https://developers.openai.com/api/reference/resources/responses); retrieved 2026-10-30 10:08:48 EDT.

**Returned function call and function result input.** The response schema declares `FunctionCall object { arguments, call_id, name, 6 more }`: `arguments: string` (a JSON string), `call_id: string`, `name: string`, and `type: "function_call"`. Its `status` is optional and, when present, one of `"in_progress"`, `"completed"`, or `"incomplete"`; the schema also lists optional `id`, `async`, `caller`, and `namespace`. The function-result input schema declares `FunctionCallOutput object { output, type, id, 5 more }`: `output` is a string or an array of text/image/file content; `type` is `"function_call_output"`; `call_id` and `name` are optional string-or-null fields; and `status` is optional string-or-null with allowed values `"in_progress"`, `"completed"`, or `"incomplete"`. The string form of `output` is documented as a JSON string with maximum length 10,485,760. Source: [Responses reference](https://developers.openai.com/api/reference/resources/responses); retrieved 2026-10-30 10:08:48 EDT.

**Stateless encrypted reasoning.** The response schema declares `Reasoning object { id, summary, type, 3 more }`, with `id: string`, `summary: array of SummaryTextContent`, `type: "reasoning"`, and optional `encrypted_content: string or null`. Each summary part has `text: string` and `type: "summary_text"`. The create reference lists `reasoning.encrypted_content` as an `include` value and says it “Includes an encrypted version of reasoning tokens in reasoning item outputs. This enables reasoning items to be used in multi-turn conversations when using the Responses API statelessly (like when the `store` parameter is set to `false`, or when an organization is enrolled in the zero data retention program).” Use the exact include value `reasoning.encrypted_content` in the request `include` array. Source: [Responses reference](https://developers.openai.com/api/reference/resources/responses), [Responses create reference](https://developers.openai.com/api/reference/resources/responses/methods/create); retrieved 2026-10-30 10:08:48 EDT.

### (c) Long-context threshold wording

The current pricing page states: “Short context: ≤272K input tokens. Long context: >272K input tokens.” Source: [pricing Markdown](https://developers.openai.com/api/docs/pricing.md), also checked in the [pricing HTML page](https://developers.openai.com/api/docs/pricing); retrieved 2026-10-30 10:08:48 EDT.

**UNVERIFIED:** an exact un-abbreviated threshold such as `272,000` tokens, or an authoritative definition of `K`. I searched both the pricing Markdown twin and the pricing HTML page for `272,000`, `272K`, standalone `K`, `thousand`, `kilo`, and threshold/long-context wording. The pages use `272K` (including the quoted definition above and model-row labels), but neither spells it out as `272,000` nor defines `K` in the pricing page or its notes.
