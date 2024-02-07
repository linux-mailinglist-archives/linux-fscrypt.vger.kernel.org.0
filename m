Return-Path: <linux-fscrypt+bounces-181-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id E0D1A84C7AA
	for <lists+linux-fscrypt@lfdr.de>; Wed,  7 Feb 2024 10:40:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 38A4DB24003
	for <lists+linux-fscrypt@lfdr.de>; Wed,  7 Feb 2024 09:40:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 45ECC2E631;
	Wed,  7 Feb 2024 09:37:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="lKxinKyj";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="WDJUNO2a";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="lKxinKyj";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="WDJUNO2a"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5108C288B0;
	Wed,  7 Feb 2024 09:37:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707298632; cv=none; b=EEdK1XojEAl3uN8TxG9U6oykmdJJCvAuNhJ/3HH1Jih+b1+4mBnQOKuQvOx+Y//52+cm+0q1lKbdi03jztLSBBwziDCFcqIPNorpEGZOtZnX59e/w5lymQca37aR2FZOEuuOB0nJizimKG4bs2bs+0ra5toNIoSzNUZbIzM7t1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707298632; c=relaxed/simple;
	bh=i0gDnOr8ChhbAJBZdzQ56mxFjoBYV4Kfk89JYVDHJm8=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=K3DFCB1Rzm1MNwOfbrcqip8vl2El4xsTQaccbKtLrik2fJV/gQlrWLPHf/nvorjpsDkL5BDor+r/niDJf5juAuMYh1fArvpFZygQNUwT95WoupQ4n1W6G5Xn+YWFby2aJ8IsnT8qWDMOdMr9yGE2DmPYTyNwEiKj7Ns39KajdKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=lKxinKyj; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=WDJUNO2a; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=lKxinKyj; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=WDJUNO2a; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 79FC122087;
	Wed,  7 Feb 2024 09:37:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1707298628; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vzj8/dPmZXFpnOLTT80VGGF37J8xoKbl58mvW09yE/k=;
	b=lKxinKyjc8MAHPT/uQa5KniKE1Jc2KNvn0dYog7udRxWztSX6FQQEEB14nLic36cztOSnm
	MpVFbcL/fS8n8KlJ+xa/liTCRlZgxrTOZcJnO0MZM869Xh25xqSuR75UMo5jCx/P58JRst
	GP21v7AZj3+MvUMATINTnuWqwTUVToo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1707298628;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vzj8/dPmZXFpnOLTT80VGGF37J8xoKbl58mvW09yE/k=;
	b=WDJUNO2aBLQP5uvJ5cJPEJJ7ZqGCTY1cNWzP2bZhBoNq0eG83+ohXoUc1oRdT5iCY0/ebD
	u5aRsFZZ3HdQSQDQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1707298628; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vzj8/dPmZXFpnOLTT80VGGF37J8xoKbl58mvW09yE/k=;
	b=lKxinKyjc8MAHPT/uQa5KniKE1Jc2KNvn0dYog7udRxWztSX6FQQEEB14nLic36cztOSnm
	MpVFbcL/fS8n8KlJ+xa/liTCRlZgxrTOZcJnO0MZM869Xh25xqSuR75UMo5jCx/P58JRst
	GP21v7AZj3+MvUMATINTnuWqwTUVToo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1707298628;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vzj8/dPmZXFpnOLTT80VGGF37J8xoKbl58mvW09yE/k=;
	b=WDJUNO2aBLQP5uvJ5cJPEJJ7ZqGCTY1cNWzP2bZhBoNq0eG83+ohXoUc1oRdT5iCY0/ebD
	u5aRsFZZ3HdQSQDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id EB8D5139D8;
	Wed,  7 Feb 2024 09:37:07 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id o0EmNkNPw2UxUgAAD6G6ig
	(envelope-from <lhenriques@suse.de>); Wed, 07 Feb 2024 09:37:07 +0000
Received: from localhost (brahms.olymp [local])
	by brahms.olymp (OpenSMTPD) with ESMTPA id 07e29045;
	Wed, 7 Feb 2024 09:37:07 +0000 (UTC)
From: Luis Henriques <lhenriques@suse.de>
To: Eric Biggers <ebiggers@kernel.org>
Cc: "Theodore Y. Ts'o" <tytso@mit.edu>,  Jaegeuk Kim <jaegeuk@kernel.org>,
  David Howells <dhowells@redhat.com>,  Jarkko Sakkinen
 <jarkko@kernel.org>,  linux-fscrypt@vger.kernel.org,
  linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fscrypt: clear keyring before calling key_put()
In-Reply-To: <20240207005731.GB35324@sol.localdomain> (Eric Biggers's message
	of "Tue, 6 Feb 2024 16:57:31 -0800")
References: <20240206101619.8083-1-lhenriques@suse.de>
	<20240207005731.GB35324@sol.localdomain>
Date: Wed, 07 Feb 2024 09:37:06 +0000
Message-ID: <87ttmkaa4d.fsf@suse.de>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Authentication-Results: smtp-out1.suse.de;
	none
X-Spam-Level: 
X-Spam-Score: -1.30
X-Spamd-Result: default: False [-1.30 / 50.00];
	 ARC_NA(0.00)[];
	 RCVD_VIA_SMTP_AUTH(0.00)[];
	 FROM_HAS_DN(0.00)[];
	 TO_DN_SOME(0.00)[];
	 TO_MATCH_ENVRCPT_ALL(0.00)[];
	 NEURAL_HAM_LONG(-1.00)[-1.000];
	 MIME_GOOD(-0.10)[text/plain];
	 RCVD_COUNT_THREE(0.00)[4];
	 DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	 NEURAL_HAM_SHORT(-0.20)[-1.000];
	 RCPT_COUNT_SEVEN(0.00)[7];
	 DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email];
	 FUZZY_BLOCKED(0.00)[rspamd.com];
	 FROM_EQ_ENVFROM(0.00)[];
	 MIME_TRACE(0.00)[0:+];
	 RCVD_TLS_LAST(0.00)[];
	 MID_RHS_MATCH_FROM(0.00)[];
	 BAYES_HAM(-0.00)[27.34%]
X-Spam-Flag: NO

Eric Biggers <ebiggers@kernel.org> writes:

> On Tue, Feb 06, 2024 at 10:16:19AM +0000, Luis Henriques wrote:
>> Now that the key quotas are handled immediately on key_put() instead of
>> being postponed to the key management garbage collection worker, a call =
to
>> keyring_clear() is all that is required in fscrypt_put_master_key() so t=
hat
>> the keyring clean-up is also done synchronously.  This patch should fix =
the
>> fstest generic/581 flakiness.
>>=20
>> Signed-off-by: Luis Henriques <lhenriques@suse.de>
>> ---
>> Hi!
>>=20
>> I know that patch "keys: update key quotas in key_put()" isn't yet merged
>> but since David and Jarkko seem to be OK with it, it doesn't hurt to send
>> this follow-up patch immediately.
>>=20
>> Cheers,
>> --=20
>> Luis
>>=20
>>  fs/crypto/keyring.c | 7 +++++--
>>  1 file changed, 5 insertions(+), 2 deletions(-)
>>=20
>> diff --git a/fs/crypto/keyring.c b/fs/crypto/keyring.c
>> index 0edf0b58daa7..dfdaae16b83a 100644
>> --- a/fs/crypto/keyring.c
>> +++ b/fs/crypto/keyring.c
>> @@ -74,8 +74,11 @@ void fscrypt_put_master_key(struct fscrypt_master_key=
 *mk)
>>  	 * that concurrent keyring lookups can no longer find it.
>>  	 */
>>  	WARN_ON_ONCE(refcount_read(&mk->mk_active_refs) !=3D 0);
>> -	key_put(mk->mk_users);
>> -	mk->mk_users =3D NULL;
>> +	if (mk->mk_users) {
>> +		keyring_clear(mk->mk_users);
>> +		key_put(mk->mk_users);
>> +		mk->mk_users =3D NULL;
>> +	}
>>  	call_rcu(&mk->mk_rcu_head, fscrypt_free_master_key);
>
> Applied, thanks.  I added a comment above the call to keyring_clear() to =
explain
> why it's there:
>
>         /* Clear the keyring so the quota gets released right away. */

Awesome, makes sense.  Thanks a lot, Eric!

Cheers,
--=20
Lu=C3=ADs

