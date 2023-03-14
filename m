Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6E9F6B8EA2
	for <lists+linux-fscrypt@lfdr.de>; Tue, 14 Mar 2023 10:25:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229534AbjCNJZf (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 14 Mar 2023 05:25:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229582AbjCNJZe (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 14 Mar 2023 05:25:34 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AFE498E9F;
        Tue, 14 Mar 2023 02:25:07 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 06334224D0;
        Tue, 14 Mar 2023 09:25:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1678785906; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LsS7UIin9FPsbS++aA53nYkwtPeYKlWQE84rzPZnqKw=;
        b=ceEbpEuUaR/l0QbCstBojFM0W4s/P3gCX3kVuG9WtJ5Yz37whOs7a2ReMSuPOyoY1Z7kO3
        4ZULbIALhUzvrlhSUEpS56m29fqh1sAuDDMy0wvOXqyV/KZr2d+PtSL7WUsxmA6WP7ct47
        jkPZOJ+jXNcNmFKucxun1jir4HQ8U+U=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1678785906;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LsS7UIin9FPsbS++aA53nYkwtPeYKlWQE84rzPZnqKw=;
        b=fkNX8Gh/3HhtseK/Ar/K6By7cCER/xdQ37ZNEGTCa/Cs5lQh76ppBtRMbe+z2ice4hJoUg
        /u4mUfy1JI0GVhAQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 6DA8713A1B;
        Tue, 14 Mar 2023 09:25:05 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 7tJ6F3E9EGR5ZwAAMHmgww
        (envelope-from <lhenriques@suse.de>); Tue, 14 Mar 2023 09:25:05 +0000
Received: from localhost (brahms.olymp [local])
        by brahms.olymp (OpenSMTPD) with ESMTPA id 098565b7;
        Tue, 14 Mar 2023 09:25:01 +0000 (UTC)
From:   =?utf-8?Q?Lu=C3=ADs_Henriques?= <lhenriques@suse.de>
To:     Xiubo Li <xiubli@redhat.com>
Cc:     Eric Biggers <ebiggers@kernel.org>,
        Jeff Layton <jlayton@kernel.org>,
        "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>,
        linux-fscrypt@vger.kernel.org, ceph-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] fscrypt: new helper function -
 fscrypt_prepare_atomic_open()
References: <20230313123310.13040-1-lhenriques@suse.de>
        <20230313123310.13040-2-lhenriques@suse.de>
        <ZA9mwPUg7H/fq0L8@sol.localdomain>
        <f72cf7fe-f489-47f2-fab9-be9eee441fca@redhat.com>
        <ZA/bJ+BNEAIsunsG@sol.localdomain>
        <46e90e39-1f7d-7260-acfc-e7ffd9aa88bd@redhat.com>
Date:   Tue, 14 Mar 2023 09:25:01 +0000
In-Reply-To: <46e90e39-1f7d-7260-acfc-e7ffd9aa88bd@redhat.com> (Xiubo Li's
        message of "Tue, 14 Mar 2023 12:20:23 +0800")
Message-ID: <878rfzvg5u.fsf@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Xiubo Li <xiubli@redhat.com> writes:

> On 14/03/2023 10:25, Eric Biggers wrote:
>> On Tue, Mar 14, 2023 at 08:53:51AM +0800, Xiubo Li wrote:
>>> On 14/03/2023 02:09, Eric Biggers wrote:
>>>> On Mon, Mar 13, 2023 at 12:33:09PM +0000, Lu=C3=ADs Henriques wrote:
>>>>> + * The regular open path will use fscrypt_file_open for that, but in=
 the
>>>>> + * atomic open a different approach is required.
>>>> This should actually be fscrypt_prepare_lookup, not fscrypt_file_open,=
 right?
>>>>
>>>>> +int fscrypt_prepare_atomic_open(struct inode *dir, struct dentry *de=
ntry)
>>>>> +{
>>>>> +	int err;
>>>>> +
>>>>> +	if (!IS_ENCRYPTED(dir))
>>>>> +		return 0;
>>>>> +
>>>>> +	err =3D fscrypt_get_encryption_info(dir, true);
>>>>> +	if (!err && !fscrypt_has_encryption_key(dir)) {
>>>>> +		spin_lock(&dentry->d_lock);
>>>>> +		dentry->d_flags |=3D DCACHE_NOKEY_NAME;
>>>>> +		spin_unlock(&dentry->d_lock);
>>>>> +	}
>>>>> +
>>>>> +	return err;
>>>>> +}
>>>>> +EXPORT_SYMBOL_GPL(fscrypt_prepare_atomic_open);
>>>> [...]
>>>>> +static inline int fscrypt_prepare_atomic_open(struct inode *dir,
>>>>> +					      struct dentry *dentry)
>>>>> +{
>>>>> +	return -EOPNOTSUPP;
>>>>> +}
>>>> This has different behavior on unencrypted directories depending on wh=
ether
>>>> CONFIG_FS_ENCRYPTION is enabled or not.  That's bad.
>>>>
>>>> In patch 2, the caller you are introducing has already checked IS_ENCR=
YPTED().
>>>>
>>>> Also, your kerneldoc comment for fscrypt_prepare_atomic_open() says it=
 is for
>>>> *encrypted* directories.
>>>>
>>>> So IMO, just remove the IS_ENCRYPTED() check from the CONFIG_FS_ENCRYP=
TION
>>>> version of fscrypt_prepare_atomic_open().
>>> IMO we should keep this check in fscrypt_prepare_atomic_open() to make =
it
>>> consistent with the existing fscrypt_prepare_open(). And we can just re=
move
>>> the check from ceph instead.
>>>
>> Well, then the !CONFIG_FS_ENCRYPTION version would need to return 0 if
>> IS_ENCRYPTED() too.
>
> For the !CONFIG_FS_ENCRYPTION version I think you mean:
>
> =C2=A0static inline int fscrypt_prepare_atomic_open(struct inode *dir, st=
ruct dentry
> *dentry)
>
> =C2=A0{
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (IS_ENCRYPTED(dir))
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 return -EOPNOTSUPP;
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return 0;
> =C2=A0}
>
>
>> Either way would be okay, but please don't do a mix of both approaches w=
ithin a
>> single function, as this patch currently does.
>>
>> Note that there are other fscrypt_* functions, such as fscrypt_get_symli=
nk(),
>> that require an IS_ENCRYPTED() inode, so that pattern is not new.
>
> Yeah, correct, I didn't notice that.

OK, thank you both for the feedback.  I'll send out v2 in a few hours.
But my preference will be to drop the IS_ENCRYPTED() from
fscrypt_prepare_atomic_open().  The reason is that we still need to keep
it in the caller function anyway, because we need to set the MDS flags
accordingly (see patch 2):

	if (IS_ENCRYPTED(dir)) {
		set_bit(CEPH_MDS_R_FSCRYPT_FILE, &req->r_req_flags);
		err =3D fscrypt_prepare_atomic_open(dir, dentry);
		if (err)
			goto out_req;
	}

Cheers,
--=20
Lu=C3=ADs
