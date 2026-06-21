<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Vehicles - Smart Car Wash</title>
    <link rel="stylesheet" href="<c:url value='/css/typography.css'/>">
    <link rel="stylesheet" href="<c:url value='/css/customer/vehicles.css'/>">
</head>
<body>
    <jsp:include page="/WEB-INF/view/common/navbar.jsp"/>
    <c:url var="defaultVehicleImage" value="/images/vehicles/car-default.svg"/>
    <c:set var="editImagePath"
           value="${empty vehicleFormData.imagePath ? '/images/vehicles/car-default.svg' : vehicleFormData.imagePath}"/>
    <c:url var="editImageUrl" value="${editImagePath}"/>

    <main class="vehicles-page">
        <header class="vehicles-heading">
            <div>
                <h1>My Vehicles</h1>
                <p>Manage your registered vehicles for faster booking and personalized care.</p>
            </div>
            <button class="primary-button" type="button" onclick="openAddForm()">+ Add Vehicle</button>
        </header>

        <c:if test="${not empty vehicleMessage}">
            <div class="alert alert-success"><c:out value="${vehicleMessage}"/></div>
        </c:if>
        <c:if test="${not empty vehicleError}">
            <div class="alert alert-error"><c:out value="${vehicleError}"/></div>
        </c:if>

        <section class="vehicle-summary">
            <span class="material-symbols-outlined">directions_car</span>
            <div>
                <small>Total Vehicles</small>
                <strong>${fn:length(vehicles)}</strong>
            </div>
        </section>

        <section class="vehicle-grid">
            <c:choose>
                <c:when test="${empty vehicles}">
                    <div class="empty-state">
                        <span class="material-symbols-outlined">directions_car</span>
                        <h2>Bạn chưa có phương tiện nào.</h2>
                        <p>Hãy thêm phương tiện để có thể đặt lịch rửa xe.</p>
                        <button class="primary-button" type="button" onclick="openAddForm()">
                            Add Vehicle
                        </button>
                    </div>
                </c:when>
                <c:otherwise>
                    <c:forEach var="vehicle" items="${vehicles}">
                        <c:set var="vehicleImage"
                               value="${empty vehicle.imagePath ? '/images/vehicles/car-default.svg' : vehicle.imagePath}"/>
                        <c:url var="vehicleImageUrl" value="${vehicleImage}"/>
                        <article class="vehicle-card">
                            <div class="vehicle-image-section">
                                <span class="active-badge">ACTIVE</span>
                                <div class="vehicle-image-wrapper">
                                    <img src="${vehicleImageUrl}"
                                         alt="<c:out value='${vehicle.brand} ${vehicle.model}'/>"
                                         class="vehicle-image"
                                         onerror="this.onerror=null;this.src='${defaultVehicleImage}';">
                                </div>
                                <span class="license-plate"><c:out value="${vehicle.licensePlate}"/></span>
                            </div>
                            <div class="vehicle-details">
                                <h2>
                                    <c:out value="${empty vehicle.brand ? 'Vehicle' : vehicle.brand}"/>
                                    <c:out value="${vehicle.model}"/>
                                </h2>
                                <p>
                                    <span class="color-dot"></span>
                                    <c:out value="${empty vehicle.color ? 'Color not specified' : vehicle.color}"/>
                                </p>
                            </div>
                            <div class="vehicle-actions">
                                <button type="button" class="edit-button"
                                        data-id="${vehicle.id}"
                                        data-plate="<c:out value='${vehicle.licensePlate}'/>"
                                        data-brand="<c:out value='${vehicle.brand}'/>"
                                        data-model="<c:out value='${vehicle.model}'/>"
                                        data-color="<c:out value='${vehicle.color}'/>"
                                        data-image="${vehicleImageUrl}"
                                        onclick="openEditForm(this)">
                                    Edit
                                </button>
                                <form method="POST" action="<c:url value='/vehicles/delete'/>"
                                      onsubmit="return confirm('Bạn có chắc muốn xóa phương tiện này?');">
                                    <input type="hidden" name="vehicleId" value="${vehicle.id}">
                                    <button type="submit" class="delete-button">Delete</button>
                                </form>
                            </div>
                        </article>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
        </section>
    </main>

    <div id="vehicleModal" class="vehicle-modal" aria-hidden="true">
        <div class="modal-panel">
            <button type="button" class="modal-close" onclick="closeVehicleForm()">×</button>

            <form id="addVehicleForm" method="POST" enctype="multipart/form-data"
                  action="<c:url value='/vehicles/add'/>">
                <h2>Add Vehicle</h2>
                <jsp:include page="/WEB-INF/view/customer/components/vehicle-fields.jsp"/>
                <div class="form-actions">
                    <button type="button" class="secondary-button" onclick="closeVehicleForm()">Cancel</button>
                    <button type="submit" class="primary-button">Add Vehicle</button>
                </div>
            </form>

            <form id="editVehicleForm" method="POST" enctype="multipart/form-data"
                  action="<c:url value='/vehicles/update'/>">
                <h2>Edit Vehicle</h2>
                <input id="editVehicleId" type="hidden" name="vehicleId"
                       value="${vehicleFormMode eq 'edit' ? vehicleFormData.id : ''}">
                <div class="form-grid">
                    <label>License Plate *
                        <input id="editLicensePlate" type="text" name="licensePlate"
                               maxlength="20" required placeholder="29A-12345"
                               value="<c:out value='${vehicleFormMode eq "edit" ? vehicleFormData.licensePlate : ""}'/>">
                    </label>
                    <label>Brand
                        <input id="editBrand" type="text" name="brand" maxlength="50" placeholder="Toyota"
                               value="<c:out value='${vehicleFormMode eq "edit" ? vehicleFormData.brand : ""}'/>">
                    </label>
                    <label>Model
                        <input id="editModel" type="text" name="model" maxlength="50" placeholder="Camry"
                               value="<c:out value='${vehicleFormMode eq "edit" ? vehicleFormData.model : ""}'/>">
                    </label>
                    <label>Color
                        <input id="editColor" type="text" name="color" maxlength="30" placeholder="White"
                               value="<c:out value='${vehicleFormMode eq "edit" ? vehicleFormData.color : ""}'/>">
                    </label>
                    <label class="image-field">Vehicle Image
                        <input id="editVehicleImage" type="file" name="vehicleImage"
                               accept="image/jpeg,image/png,image/webp">
                    </label>
                </div>
                <div class="vehicle-preview-wrapper">
                    <img id="editImagePreview" src="${editImageUrl}"
                         alt="Vehicle preview" class="vehicle-preview-image"
                         onerror="this.onerror=null;this.src='${defaultVehicleImage}';">
                </div>
                <div class="form-actions">
                    <button type="button" class="secondary-button" onclick="closeVehicleForm()">Cancel</button>
                    <button type="submit" class="primary-button">Save Changes</button>
                </div>
            </form>
        </div>
    </div>

    <script>
        var modal = document.getElementById('vehicleModal');
        var addForm = document.getElementById('addVehicleForm');
        var editForm = document.getElementById('editVehicleForm');
        var addPreviewUrl = null;
        var editPreviewUrl = null;

        function showModal(form) {
            addForm.style.display = form === addForm ? 'block' : 'none';
            editForm.style.display = form === editForm ? 'block' : 'none';
            modal.classList.add('show');
            modal.setAttribute('aria-hidden', 'false');
        }

        function openAddForm() {
            addForm.reset();
            setPreview(document.getElementById('addImagePreview'),
                    '${defaultVehicleImage}', 'add');
            showModal(addForm);
        }

        function openEditForm(button) {
            document.getElementById('editVehicleId').value = button.dataset.id;
            document.getElementById('editLicensePlate').value = button.dataset.plate || '';
            document.getElementById('editBrand').value = button.dataset.brand || '';
            document.getElementById('editModel').value = button.dataset.model || '';
            document.getElementById('editColor').value = button.dataset.color || '';
            document.getElementById('editVehicleImage').value = '';
            setPreview(document.getElementById('editImagePreview'),
                    button.dataset.image || '${defaultVehicleImage}', 'edit');
            showModal(editForm);
        }

        function setPreview(preview, source, type) {
            if (type === 'add' && addPreviewUrl) {
                URL.revokeObjectURL(addPreviewUrl);
                addPreviewUrl = null;
            }
            if (type === 'edit' && editPreviewUrl) {
                URL.revokeObjectURL(editPreviewUrl);
                editPreviewUrl = null;
            }
            preview.src = source;
        }

        function bindImagePreview(inputId, previewId, type) {
            var input = document.getElementById(inputId);
            var preview = document.getElementById(previewId);
            input.addEventListener('change', function () {
                var file = input.files && input.files[0];
                if (!file) {
                    return;
                }
                if (type === 'add' && addPreviewUrl) {
                    URL.revokeObjectURL(addPreviewUrl);
                }
                if (type === 'edit' && editPreviewUrl) {
                    URL.revokeObjectURL(editPreviewUrl);
                }
                var objectUrl = URL.createObjectURL(file);
                if (type === 'add') {
                    addPreviewUrl = objectUrl;
                } else {
                    editPreviewUrl = objectUrl;
                }
                preview.src = objectUrl;
            });
        }

        function closeVehicleForm() {
            if (addPreviewUrl) {
                URL.revokeObjectURL(addPreviewUrl);
                addPreviewUrl = null;
            }
            if (editPreviewUrl) {
                URL.revokeObjectURL(editPreviewUrl);
                editPreviewUrl = null;
            }
            modal.classList.remove('show');
            modal.setAttribute('aria-hidden', 'true');
        }

        modal.addEventListener('click', function (event) {
            if (event.target === modal) {
                closeVehicleForm();
            }
        });

        bindImagePreview('addVehicleImage', 'addImagePreview', 'add');
        bindImagePreview('editVehicleImage', 'editImagePreview', 'edit');

        <c:if test="${vehicleFormMode eq 'add'}">
            showModal(addForm);
        </c:if>
        <c:if test="${vehicleFormMode eq 'edit'}">
            showModal(editForm);
        </c:if>
    </script>
</body>
</html>
