package br.com.raptorslog.repository;

import br.com.raptorslog.model.Entrega;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.repository.PagingAndSortingRepository;
import org.springframework.data.repository.query.Param;
import org.springframework.data.rest.core.annotation.RepositoryRestResource;
import org.springframework.data.rest.core.annotation.RestResource;

@RepositoryRestResource(collectionResourceRel = "entregas", path = "entregas")
public interface EntregaRepository extends PagingAndSortingRepository<Entrega, Long> {


    @RestResource(path = "nameStartsWith", rel = "nameStartsWith")
    public Page findByNameStartsWith(@Param("name") String name, Pageable p);


}
