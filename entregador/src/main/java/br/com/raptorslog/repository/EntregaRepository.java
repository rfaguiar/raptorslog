package br.com.raptorslog.repository;

import br.com.raptorslog.model.Entrega;
import org.springframework.data.repository.CrudRepository;
import org.springframework.data.rest.core.annotation.RepositoryRestResource;

@RepositoryRestResource(collectionResourceRel = "entregas", path = "entregas")
public interface EntregaRepository extends CrudRepository<Entrega, Long> {
}
