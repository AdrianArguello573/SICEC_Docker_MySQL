
const $=s=>document.querySelector(s), $$=s=>[...document.querySelectorAll(s)];
const esc=s=>String(s??"").replace(/[&<>"']/g,m=>({"&":"&amp;","<":"&lt;",">":"&gt;",'"':"&quot;","'":"&#039;"}[m]));
const K="sicec_doctor_full_v1";

const initial={
 patients:[{
  id:1,exp:"HC-00124",name:"María López Hernández",curp:"LOHM900314MCSXXX01",birth:"1990-03-14",sex:"Femenino",blood:"O+",allergy:"Penicilina",
  phone:"961 123 4567",email:"maria.lopez@email.com",city:"Tuxtla Gutiérrez, Chiapas",
  reason:"Dolor de garganta y fiebre.",illness:"Inicia hace 3 días con odinofagia, fiebre no cuantificada, malestar general y cefalea leve. Niega tos productiva. Automedicación con paracetamol con alivio parcial.",
  exam:"Orofaringe eritematosa con exudado blanquecino. Adenopatías cervicales palpables. Campos pulmonares sin estertores. Resto de la exploración sin datos relevantes.",
  dx:"Faringoamigdalitis aguda de probable origen bacteriano.",plan:"Paracetamol 500 mg VO cada 8 horas por 3 días.\nAmoxicilina 500 mg VO cada 8 horas por 7 días.\nReposo e hidratación abundante.\nAcudir a control en 5 días.",
  alerts:["Alergia a penicilina","Diabetes mellitus tipo 2","Hipertensión arterial"],
  history:["Diabetes mellitus tipo 2 · Dx. 2018","Hipertensión arterial · Dx. 2020","Colecistectomía · 2015","Niega tabaquismo","Niega alcoholismo"],
  vitals:{sys:118,dia:76,fc:92,fr:18,temp:38.1,spo2:98,weight:68,height:1.65,glucose:95,pain:3,time:"10:05"},
  studies:[{type:"Biometría hemática",date:"12/02/2024",status:"Normal"},{type:"Química sanguínea",date:"12/02/2024",status:"Normal"},{type:"EGO",date:"10/01/2024",status:"Normal"}]
 }],
 selectedId:1,
 agenda:[
  {id:1,time:"09:00",patient:"María López Hernández",reason:"Consulta de seguimiento",status:"En consulta"},
  {id:2,time:"09:30",patient:"José Ramírez Soto",reason:"Primera vez",status:"En espera"},
  {id:3,time:"10:00",patient:"Ana Torres Vázquez",reason:"Control de hipertensión",status:"En espera"},
  {id:4,time:"10:30",patient:"Luis García Morales",reason:"Dolor lumbar",status:"En espera"},
  {id:5,time:"11:00",patient:"Carmen Díaz Ruiz",reason:"Resultados de estudios",status:"Programada"}
 ],
 consultations:[{id:1,date:"23/04/2024",patient:"María López Hernández",reason:"Dolor de garganta y fiebre",dx:"Faringoamigdalitis aguda",note:"Seguimiento ambulatorio."}],
 rx:[{id:1,date:"23/04/2024",patient:"María López Hernández",drug:"Paracetamol 500 mg",dose:"1 tableta",freq:"Cada 8 horas",duration:"3 días",notes:"Tomar con alimentos."}],
 studies:[{id:1,date:"23/04/2024",patient:"María López Hernández",type:"Biometría hemática",status:"Normal",obs:"Sin alteraciones relevantes"}],
 notes:[]
};
let state;
try{state=JSON.parse(localStorage.getItem(K))||structuredClone(initial)}catch{state=JSON.parse(JSON.stringify(initial))}
let hydrated=false; let saveTimer; const save=()=>{if(!hydrated)return;clearTimeout(saveTimer);saveTimer=setTimeout(async()=>{try{const r=await fetch('/api/estado',{method:'PUT',headers:{'Content-Type':'application/json'},body:JSON.stringify(state)});if(!r.ok)throw Error(await r.text());document.getElementById('dbStatus').textContent='● MySQL conectado';}catch(e){console.error(e);document.getElementById('dbStatus').textContent='● Error al guardar en MySQL';toast('Error de base de datos','No se guardaron los cambios.','warn');}},350)};
const age=b=>{const d=new Date(b+"T00:00:00"),n=new Date();let a=n.getFullYear()-d.getFullYear();const m=n.getMonth()-d.getMonth();if(m<0||(m===0&&n.getDate()<d.getDate()))a--;return a};
const init=n=>n.split(/\s+/).slice(0,2).map(x=>x[0]).join("").toUpperCase();
const selected=()=>state.patients.find(p=>p.id===state.selectedId)||state.patients[0];

function toast(title,msg,type="success"){const e=document.createElement("div");e.className="toast "+(type==="error"?"err":type);e.innerHTML=`<div>${type==="warn"?"⚠":type==="info"?"ℹ":"✓"}</div><div><strong>${esc(title)}</strong><p>${esc(msg)}</p></div>`;$("#toastWrap").appendChild(e);setTimeout(()=>e.remove(),3200)}
function openM(id){$("#"+id).classList.add("show");fillSelects()}
function closeM(id){$("#"+id).classList.remove("show")}
$$("[data-close]").forEach(b=>b.addEventListener("click",()=>closeM(b.dataset.close)));$$(".modalwrap").forEach(m=>m.addEventListener("click",e=>{if(e.target===m)closeM(m.id)}))
function showPage(id){$$(".page").forEach(p=>p.classList.remove("active"));$("#"+id).classList.add("active");$$(".nav button").forEach(b=>b.classList.toggle("active",b.dataset.page===id))}
$$(".nav button").forEach(b=>b.onclick=()=>showPage(b.dataset.page));$$("[data-go]").forEach(b=>b.onclick=()=>showPage(b.dataset.go));

function fillSelects(){const o=state.patients.map(p=>`<option value="${p.id}">${esc(p.name)} · ${esc(p.exp)}</option>`).join("");["#cPatient","#rPatient","#sPatient","#aPatient"].forEach(id=>$(id).innerHTML=o)}
function renderStats(){$("#statPacientes").textContent=state.patients.length;$("#statConsultas").textContent=state.consultations.filter(c=>c.date===new Date().toLocaleDateString("es-MX")).length+8;$("#statEstudios").textContent=state.studies.filter(s=>s.status==="Pendiente").length;$("#statRecetas").textContent=state.rx.length}
function renderAgenda(){const html=state.agenda.map((a,i)=>`<div class="agenda-item ${i===0?"active":""}"><div class="time">${esc(a.time)}</div><div><strong>${esc(a.patient)}</strong><div class="small">${esc(a.reason)}</div></div><span class="tag ${a.status==="En consulta"?"green":a.status==="Programada"?"blue":"gray"}">${esc(a.status)}</span></div>`).join("");$("#agendaMini").innerHTML=html;$("#agendaFull").innerHTML=html}
function renderSelected(){const p=selected();if(!p)return;state.selectedId=p.id;$("#pAvatar").textContent=init(p.name);$("#pName").textContent=p.name;$("#pExp").textContent=p.exp;$("#pAge").textContent=age(p.birth)+" años";$("#pBirth").textContent=new Date(p.birth+"T00:00:00").toLocaleDateString("es-MX");$("#pSex").textContent=p.sex;$("#pBlood").textContent=p.blood;$("#pAllergy").textContent=p.allergy||"Ninguna";$("#pPhone").textContent=p.phone||"Sin teléfono";$("#pEmail").textContent=p.email||"Sin correo";$("#pCity").textContent=p.city||"Sin ciudad";$("#motivoTxt").textContent=p.reason||"Sin registro";$("#padecimientoTxt").textContent=p.illness||"Sin registro";$("#exploracionTxt").textContent=p.exam||"Sin registro";$("#dxTxt").textContent=p.dx||"Sin registro";$("#planTxt").innerHTML=esc(p.plan||"Sin registro").replace(/\n/g,"<br>");
const v=p.vitals||{};$("#vTA").textContent=`${v.sys??"—"}/${v.dia??"—"}`;$("#vFC").textContent=v.fc??"—";$("#vFR").textContent=v.fr??"—";$("#vTemp").textContent=v.temp??"—";$("#vSpO2").textContent=v.spo2??"—";$("#vitalTime").textContent=v.time?`(${v.time} hrs)`:"";$("#vWeight").textContent=v.weight??"—";$("#vHeight").textContent=v.height??"—";const bmi=v.weight&&v.height?(v.weight/(v.height*v.height)).toFixed(1):"—";$("#vBMI").textContent=bmi;
$("#alertsList").innerHTML=(p.alerts||[]).map(x=>`<li>${esc(x)}</li>`).join("")||"<li>Sin alertas</li>";$("#historyList").innerHTML=(p.history||[]).map(x=>`<li>${esc(x)}</li>`).join("")||"<li>Sin antecedentes</li>";$("#recentStudies").innerHTML=(p.studies||[]).slice(0,4).map(s=>`<div class="study"><div><strong>${esc(s.type)}</strong><div class="small">${esc(s.date)}</div></div><span class="tag green">${esc(s.status)}</span></div>`).join("")||'<div class="small">Sin estudios</div>'}
function renderPatients(){const q=($("#patientSearch").value||$("#globalSearch").value||"").toLowerCase();const arr=state.patients.filter(p=>!q||p.name.toLowerCase().includes(q)||p.exp.toLowerCase().includes(q)||(p.curp||"").toLowerCase().includes(q));$("#patientsRows").innerHTML=arr.map(p=>`<tr><td>${esc(p.exp)}</td><td><strong>${esc(p.name)}</strong></td><td>${age(p.birth)}</td><td>${esc(p.sex)}</td><td>${esc(p.allergy||"Ninguna")}</td><td><button class="btn soft" onclick="selectPatient(${p.id})">Abrir</button> <button class="btn ghost" onclick="editPatient(${p.id})">Editar</button></td></tr>`).join("")}
function renderTables(){$("#consultRows").innerHTML=state.consultations.map(c=>`<tr><td>${esc(c.date)}</td><td>${esc(c.patient)}</td><td>${esc(c.reason)}</td><td>${esc(c.dx)}</td><td>${esc(c.note||"")}</td></tr>`).join("");$("#rxRows").innerHTML=state.rx.map(r=>`<tr><td>${esc(r.date)}</td><td>${esc(r.patient)}</td><td>${esc(r.drug)}</td><td>${esc(r.dose)}</td><td>${esc(r.freq)}</td><td>${esc(r.duration)}</td></tr>`).join("");$("#studyRows").innerHTML=state.studies.map(s=>`<tr><td>${esc(s.date)}</td><td>${esc(s.patient)}</td><td>${esc(s.type)}</td><td>${esc(s.status)}</td><td>${esc(s.obs||"")}</td></tr>`).join("");$("#notesList").innerHTML=state.notes.length?state.notes.map(n=>`<div class="box" style="margin-bottom:10px"><strong>${esc(n.patient)} · ${esc(n.date)}</strong><p style="margin-top:6px">${esc(n.text)}</p></div>`).join(""):'<div class="small">Aún no hay notas guardadas.</div>'}
function renderAll(persist=true){renderStats();renderAgenda();renderSelected();renderPatients();renderTables();fillSelects();if(persist)save()}
window.selectPatient=id=>{state.selectedId=id;renderAll();showPage("inicio");toast("Paciente cargado","Expediente abierto correctamente","info")};

let editingPatientId=null,textField=null,listField=null;
window.editPatient=id=>{editingPatientId=id;const p=state.patients.find(x=>x.id===id);$("#patientModalTitle").textContent="Editar paciente";$("#fName").value=p.name;$("#fCurp").value=p.curp||"";$("#fBirth").value=p.birth;$("#fSex").value=p.sex;$("#fBlood").value=p.blood;$("#fAllergy").value=p.allergy||"";$("#fPhone").value=p.phone||"";$("#fEmail").value=p.email||"";$("#fCity").value=p.city||"";openM("modalPatient")};
function newPatient(){editingPatientId=null;$("#patientModalTitle").textContent="Nuevo paciente";$("#patientForm").reset();$("#fCity").value="Tuxtla Gutiérrez, Chiapas";openM("modalPatient")}
["#btnAddPaciente","#btnAddPaciente2"].forEach(id=>$(id).onclick=newPatient);
$("#patientForm").onsubmit=e=>{e.preventDefault();const data={name:$("#fName").value.trim(),curp:$("#fCurp").value.trim(),birth:$("#fBirth").value,sex:$("#fSex").value,blood:$("#fBlood").value,allergy:$("#fAllergy").value.trim(),phone:$("#fPhone").value.trim(),email:$("#fEmail").value.trim(),city:$("#fCity").value.trim()};if(editingPatientId){Object.assign(state.patients.find(p=>p.id===editingPatientId),data);toast("Paciente actualizado","Los datos fueron guardados.")}else{const id=Date.now();state.patients.unshift({id,exp:"HC-"+String(state.patients.length+125).padStart(5,"0"),...data,reason:"Consulta general",illness:"Sin registro",exam:"Sin registro",dx:"Pendiente",plan:"Pendiente",alerts:[],history:[],vitals:{sys:120,dia:80,fc:72,fr:16,temp:36.5,spo2:98,weight:70,height:1.70,glucose:90,pain:0,time:new Date().toLocaleTimeString("es-MX",{hour:"2-digit",minute:"2-digit"})},studies:[]});state.selectedId=id;toast("Paciente agregado","Nuevo expediente creado.")}closeM("modalPatient");renderAll()};

$("#btnEditPaciente").onclick=()=>editPatient(state.selectedId);
$("#btnDeletePaciente").onclick=()=>{if(state.patients.length<=1){toast("No permitido","Debe existir al menos un paciente.","warn");return}if(confirm("¿Eliminar este paciente de la demo?")){state.patients=state.patients.filter(p=>p.id!==state.selectedId);state.selectedId=state.patients[0].id;renderAll();toast("Paciente eliminado","Se eliminó de esta demo.","warn")}};

function editVitals(){const v=selected().vitals||{};$("#fSys").value=v.sys??120;$("#fDia").value=v.dia??80;$("#fFC").value=v.fc??72;$("#fFR").value=v.fr??16;$("#fTemp").value=v.temp??36.5;$("#fSpO2").value=v.spo2??98;$("#fWeight").value=v.weight??70;$("#fHeight").value=v.height??1.70;$("#fGlucose").value=v.glucose??90;$("#fPain").value=v.pain??0;openM("modalVitals")}
$("#btnEditVitals").onclick=editVitals;$("#btnEditVitals2").onclick=editVitals;
$("#vitalsForm").onsubmit=e=>{e.preventDefault();const nums=["fSys","fDia","fFC","fFR","fTemp","fSpO2","fWeight","fHeight","fGlucose","fPain"].map(id=>Number($("#"+id).value||0));const [sys,dia,fc,fr,temp,spo2,weight,height,glucose,pain]=nums;if(sys<=dia){toast("Revisa la TA","La sistólica debe ser mayor que la diastólica.","warn");return}selected().vitals={sys,dia,fc,fr,temp,spo2,weight,height,glucose,pain,time:new Date().toLocaleTimeString("es-MX",{hour:"2-digit",minute:"2-digit"})};closeM("modalVitals");renderAll();toast("Signos vitales actualizados","Los nuevos valores quedaron guardados.")};

function openText(field,title,label){textField=field;$("#textTitle").textContent=title;$("#textLabel").textContent=label;$("#textValue").value=selected()[field]||"";openM("modalText")}
$("#btnEditMotivo").onclick=()=>openText("reason","Editar motivo de consulta","Motivo de consulta");
$("#btnEditPadecimiento").onclick=()=>openText("illness","Editar padecimiento actual","Padecimiento actual");
$("#btnEditExploracion").onclick=()=>openText("exam","Editar exploración física","Exploración física");
$("#btnEditDx").onclick=()=>openText("dx","Editar diagnóstico","Diagnóstico presuntivo");
$("#btnEditPlan").onclick=()=>openText("plan","Editar tratamiento","Plan terapéutico");
$("#textForm").onsubmit=e=>{e.preventDefault();selected()[textField]=$("#textValue").value.trim();closeM("modalText");renderAll();toast("Cambios guardados","La información clínica fue actualizada.")};

function openList(field,title){listField=field;$("#listTitle").textContent=title;$("#listValue").value=(selected()[field]||[]).join("\n");openM("modalList")}
$("#btnEditAlerts").onclick=()=>openList("alerts","Editar alertas clínicas");$("#btnEditHistory").onclick=()=>openList("history","Editar antecedentes relevantes");
$("#listForm").onsubmit=e=>{e.preventDefault();selected()[listField]=$("#listValue").value.split("\n").map(x=>x.trim()).filter(Boolean);closeM("modalList");renderAll();toast("Lista actualizada","Cambios guardados correctamente.")};

function openConsult(){openM("modalConsult");$("#cPatient").value=state.selectedId}function openRx(){openM("modalRx");$("#rPatient").value=state.selectedId}function openStudy(){openM("modalStudy");$("#sPatient").value=state.selectedId}function openAppointment(){openM("modalAppointment");$("#aPatient").value=state.selectedId}
["#btnAddConsulta","#btnAddConsulta2"].forEach(id=>$(id).onclick=openConsult);["#btnCreateRx","#btnAddRx"].forEach(id=>$(id).onclick=openRx);["#btnCreateStudy","#btnAddStudy"].forEach(id=>$(id).onclick=openStudy);["#btnAddCita","#btnAddCita2"].forEach(id=>$(id).onclick=openAppointment);

$("#consultForm").onsubmit=e=>{e.preventDefault();const p=state.patients.find(x=>x.id==$("#cPatient").value);const item={id:Date.now(),date:new Date().toLocaleDateString("es-MX"),patient:p.name,reason:$("#cReason").value.trim(),dx:$("#cDx").value.trim(),note:$("#cNote").value.trim()};state.consultations.unshift(item);if(p.id===state.selectedId){p.reason=item.reason;p.dx=item.dx}e.target.reset();closeM("modalConsult");renderAll();toast("Consulta registrada","La consulta quedó guardada.")};
$("#rxForm").onsubmit=e=>{e.preventDefault();const p=state.patients.find(x=>x.id==$("#rPatient").value);state.rx.unshift({id:Date.now(),date:new Date().toLocaleDateString("es-MX"),patient:p.name,drug:$("#rDrug").value.trim(),dose:$("#rDose").value.trim(),freq:$("#rFreq").value.trim(),duration:$("#rDuration").value.trim(),notes:$("#rNotes").value.trim()});e.target.reset();closeM("modalRx");renderAll();toast("Receta creada","La receta fue registrada.")};
$("#studyForm").onsubmit=e=>{e.preventDefault();const p=state.patients.find(x=>x.id==$("#sPatient").value);const obj={id:Date.now(),date:new Date().toLocaleDateString("es-MX"),patient:p.name,type:$("#sType").value.trim(),status:$("#sStatus").value,obs:$("#sObs").value.trim()};state.studies.unshift(obj);p.studies.unshift({type:obj.type,date:obj.date,status:obj.status});e.target.reset();closeM("modalStudy");renderAll();toast("Estudio registrado","Se agregó al expediente.")};
$("#appointmentForm").onsubmit=e=>{e.preventDefault();const p=state.patients.find(x=>x.id==$("#aPatient").value);state.agenda.push({id:Date.now(),time:$("#aTime").value,patient:p.name,reason:$("#aReason").value.trim(),status:$("#aStatus").value});state.agenda.sort((a,b)=>a.time.localeCompare(b.time));e.target.reset();closeM("modalAppointment");renderAll();toast("Cita agendada","Se agregó a la agenda.")};

$("#btnSaveNote").onclick=()=>{const p=selected();const text=`Motivo: ${p.reason}\nPadecimiento: ${p.illness}\nExploración: ${p.exam}\nDiagnóstico: ${p.dx}\nPlan: ${p.plan}`;state.notes.unshift({id:Date.now(),date:new Date().toLocaleString("es-MX"),patient:p.name,text});renderAll();toast("Nota guardada","Se agregó a Notas clínicas.")};
$("#btnPrintLastRx").onclick=()=>{if(!state.rx.length){toast("Sin recetas","No hay recetas para imprimir.","warn");return}const r=state.rx[0];const w=window.open("","_blank","width=760,height=700");w.document.write(`<html><head><title>Receta médica</title><style>body{font-family:Arial;padding:40px;color:#17324a}h1{color:#176caa}.box{border:1px solid #ccd8e2;padding:20px;border-radius:12px}p{line-height:1.5}</style></head><body><h1>HealthCare - Receta médica</h1><div class="box"><p><strong>Paciente:</strong> ${esc(r.patient)}</p><p><strong>Fecha:</strong> ${esc(r.date)}</p><p><strong>Medicamento:</strong> ${esc(r.drug)}</p><p><strong>Dosis:</strong> ${esc(r.dose)}</p><p><strong>Frecuencia:</strong> ${esc(r.freq)}</p><p><strong>Duración:</strong> ${esc(r.duration)}</p><p><strong>Indicaciones:</strong> ${esc(r.notes||"")}</p><br><p>Dr. Carlos Mendoza</p></div><script>window.print()<\/script><div id="dbStatus" style="position:fixed;bottom:12px;right:14px;background:#12385a;color:white;padding:8px 14px;border-radius:12px;font:12px Arial;z-index:9999">● Conectando MySQL...</div>
</body></html>`);w.document.close()};
$("#bellBtn").onclick=()=>toast("Notificaciones","Tienes alertas clínicas y estudios por revisar.","info");
$("#globalSearch").oninput=()=>{renderPatients();if($("#globalSearch").value.trim())showPage("pacientes")};$("#patientSearch").oninput=renderPatients;
$("#btnReset").onclick=()=>{if(confirm("¿Restablecer toda la demo?")){fetch('/api/estado/reset',{method:'POST'}).then(()=>location.reload()).catch(()=>toast('Error','No se pudo restablecer','warn'))}};

$("#agendaDate").textContent=new Date().toLocaleDateString("es-MX",{weekday:"long",day:"numeric",month:"long",year:"numeric"});
renderAll(false);(async()=>{try{const r=await fetch('/api/estado');if(!r.ok)throw Error(await r.text());const data=await r.json();if(data && typeof data==='object' && Array.isArray(data.patients)){state=data;renderAll(false)}document.getElementById('dbStatus').textContent='● MySQL conectado';}catch(e){console.error(e);document.getElementById('dbStatus').textContent='● Sin conexión a MySQL';toast('Sin conexión','Revisa Docker y el backend.','warn')}})();


// ========= PANELES POR PERFIL (DEMO, NO CONTROL DE ACCESO) =========
let adminConsultas = [];
const getApi = async url => { const response = await fetch(url); if(!response.ok) throw new Error('Error HTTP '+response.status); return response.json(); };
const contentOrEmpty = (element, value) => { element.textContent = value || 'Sin registros disponibles'; };
async function loadAdmin(){
  const [patients, staff, services, consultations] = await Promise.allSettled([
    getApi('/api/pacientes'),getApi('/api/medicos'),getApi('/api/servicios'),getApi('/api/consultas')
  ]);
  const value = r => r.status === 'fulfilled' ? r.value : null;
  const pp=value(patients), ss=value(staff), sv=value(services), cc=value(consultations);
  document.getElementById('admPatients').textContent = pp?.total ?? '—';
  document.getElementById('admStaff').textContent = ss?.medicos?.length ?? '—';
  document.getElementById('admServices').textContent = sv?.servicios?.length ?? '—';
  document.getElementById('admConsultations').textContent = cc?.total ?? '—';
  const staffRows=document.getElementById('admStaffRows');
  staffRows.innerHTML=(ss?.medicos||[]).map(m=>`<tr><td>${esc(m.nombre_completo)}</td><td>${esc(m.tipo_personal)}</td><td>${esc(m.especialidad||'—')}</td></tr>`).join('') || '<tr><td colspan="3">Sin datos o servicio no disponible</td></tr>';
  const consultationRows=document.getElementById('admConsultRows');
  adminConsultas=cc?.consultas||[];
  consultationRows.innerHTML=adminConsultas.slice(0,12).map(c=>`<tr><td>${esc(c.paciente)}</td><td>${esc(c.medico)}</td><td>${esc(c.servicio)}</td><td>${esc(c.fecha_hora_inicio)}</td></tr>`).join('') || '<tr><td colspan="4">Sin datos o servicio no disponible</td></tr>';
}
document.getElementById('refreshAdmin').addEventListener('click',loadAdmin);
function renderPatientPortal(){
  const selector=document.getElementById('portalPatient');
  const current=selector.value || String(state.selectedId);
  selector.innerHTML=state.patients.map(p=>`<option value="${esc(p.id)}">${esc(p.name)} · ${esc(p.exp)}</option>`).join('');
  if(state.patients.some(p=>String(p.id)===current)) selector.value=current;
  const p=state.patients.find(p=>String(p.id)===selector.value) || state.patients[0];
  if(!p){document.getElementById('portalDetails').textContent='Sin expedientes de demostración';return;}
  const fields=[['Nombre',p.name],['Expediente',p.exp],['Nacimiento',p.birth],['Teléfono',p.phone||'—'],['Sexo',p.sex],['Ciudad',p.city||'—']];
  document.getElementById('portalDetails').innerHTML=fields.map(([key,val])=>`<div><dt>${esc(key)}</dt><dd>${esc(val)}</dd></div>`).join('');
  const appointments=state.agenda.filter(a=>a.patient===p.name);
  const appt=document.getElementById('portalAppointments');
  appt.innerHTML=appointments.map(a=>`<div class="portal-item"><strong>${esc(a.reason)}</strong><div class="small">${esc(a.time)} · ${esc(a.status)}</div></div>`).join('') || '<p class="small">No hay citas en el estado de la aplicación.</p>';
  const consultations=state.consultations.filter(c=>c.patient===p.name);
  const cons=document.getElementById('portalConsultations');
  cons.innerHTML=consultations.map(c=>`<div class="portal-item"><strong>${esc(c.date)}</strong><div class="small">${esc(c.reason||'Consulta')}</div></div>`).join('') || '<p class="small">Sin consultas en el estado de la aplicación.</p>';
}
document.getElementById('portalPatient').addEventListener('change',renderPatientPortal);
