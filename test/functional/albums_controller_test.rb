require 'test_helper'

class AlbumsControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:albums)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_album
    assert_difference('Album.count') do
      post :create, :album => { }
    end

    assert_redirected_to album_path(assigns(:album))
  end

  def test_should_show_album
    get :show, :id => albums(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => albums(:one).id
    assert_response :success
  end

  def test_should_update_album
    put :update, :id => albums(:one).id, :album => { }
    assert_redirected_to album_path(assigns(:album))
  end

  def test_should_destroy_album
    assert_difference('Album.count', -1) do
      delete :destroy, :id => albums(:one).id
    end

    assert_redirected_to albums_path
  end
end
