/*
 * Copyright (©) Residential Way, 2016 - 2017, All rights reserved. The
 * intellectual and technical concepts contained herein are proprietary to
 * Residential Way and its suppliers and may be covered by U.S. and Foreign
 * Patents, patents in process, and are protected by trade secret or copyright
 * law. Unauthorized copying of this file, via any medium is strictly
 * prohibited. Proprietary and confidential.
 */
package com.resway.server.domain.key;

import javax.persistence.Embeddable;

import com.resway.server.domain.entity.UserVerification;
import com.resway.server.framework.entity.domain.AbstractDomainKey;

/**
 * Key class for {@link UserVerification}.
 *
 * @author Kevin
 * @since 1.0.0
 */
@Embeddable
public class UserVerificationKey extends AbstractDomainKey {
	/** Serial version id. */
	private static final long serialVersionUID = -2089566481434119358L;
	/** The article id. */
	private int id;

	/**
	 * Indicates the unique id for user verification
	 *
	 * @return the id for the user verfication attribute
	 */
	public int getId() {
		return id;
	}

	/**
	 * Fetches the id for the user verfication attribute
	 *
	 * @param verificationId
	 *            the id for the user verfication attribute
	 */
	public void getId(int verificationId) {
		this.id = verificationId;
	}

	/*
	 * (non-Javadoc)
	 * @see java.lang.Object#hashCode()
	 */
	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + id;
		return result;
	}

	/*
	 * (non-Javadoc)
	 * @see java.lang.Object#equals(java.lang.Object)
	 */
	@Override
	public boolean equals(Object obj) {
		if (this == obj) {
			return true;
		}
		if (obj == null) {
			return false;
		}
		if (getClass() != obj.getClass()) {
			return false;
		}
		UserVerificationKey other = (UserVerificationKey) obj;
		if (id != other.id) {
			return false;
		}
		return true;
	}

	/*
	 * (non-Javadoc)
	 * @see java.lang.Object#toString()
	 */
	@Override
	public String toString() {
		return "UserVerificationKey [id=" + id + "]";
	}
}
