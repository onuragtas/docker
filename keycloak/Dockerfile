FROM quay.io/keycloak/keycloak:25.0.1 AS builder

# Configure a database vendor
ENV KC_DB=postgres

WORKDIR /opt/keycloak
# COPY --from=keycloakify_jar_builder /opt/app/build_keycloak/target/ keycloakify-starter-keycloak-theme-5.1.3.jar /opt/keycloak/providers/
RUN /opt/keycloak/bin/kc.sh build

FROM quay.io/keycloak/keycloak:25.0.1
COPY --from=builder /opt/keycloak/ /opt/keycloak/

# Add ENTRYPOINT
ENTRYPOINT ["/opt/keycloak/bin/kc.sh", "start-dev", "--features=scripts"]