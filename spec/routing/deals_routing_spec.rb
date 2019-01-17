require 'rails_helper'

describe 'routes for admin namespace' do
  context 'for deals controller' do
    describe 'restful routes' do
      it 'routes GET admin/deals to the index action' do
        expect(get('/admin/deals')).
          to route_to('admin/deals#index')
      end
      it 'routes GET admin/deals/new to the new action' do
        expect(get('/admin/deals/new')).
          to route_to('admin/deals#new')
      end
      it 'routes POST admin/deals to the create action' do
        expect(post('/admin/deals/')).
          to route_to('admin/deals#create')
      end
      it 'routes GET admin/deals/:id to the show action' do
        expect(get('/admin/deals/1')).
          to route_to(controller: 'admin/deals', action: 'show', id: '1')
      end
      it 'routes GET admin/deals/:id/edit to the edit action' do
        expect(get('/admin/deals/1/edit')).
          to route_to(controller: 'admin/deals', action: 'edit', id: '1')
      end
      it 'routes PATCH admin/deals/:id/update to the update action' do
        expect(patch('/admin/deals/1')).
          to route_to(controller: 'admin/deals', action: 'update', id: '1')
      end
      it 'routes DELETE admin/deals/:id to the destroy action' do
        expect(delete('/admin/deals/1')).
          to route_to(controller: 'admin/deals', action: 'destroy', id: '1')
      end
    end
  end
end
