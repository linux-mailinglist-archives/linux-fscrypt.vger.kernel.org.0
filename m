Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5050B6B3EA9
	for <lists+linux-fscrypt@lfdr.de>; Fri, 10 Mar 2023 13:05:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229936AbjCJMFv (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 10 Mar 2023 07:05:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229913AbjCJMFt (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 10 Mar 2023 07:05:49 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2CF2EA014;
        Fri, 10 Mar 2023 04:05:47 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 4A22322A98;
        Fri, 10 Mar 2023 12:05:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1678449946; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=k6lGtX45aQeF36lTGiVeBvqf1CI5X3sksG7oKS/gG5k=;
        b=njDc490kvCw9DcdNEoifK7T5faKZdoqKFI5wlQiiCaj9fH/Y+g3CabK7bAPxldTEoEWSFk
        mN27qODCXVNhz+xOe8apcUwqcFQbMR3ameAldT3uHFLg14Z67qG9bmpnZUipw9iuh+G3ze
        BNC8t6b+siUY7iGHBFqx6IrpJLA0jGo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1678449946;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=k6lGtX45aQeF36lTGiVeBvqf1CI5X3sksG7oKS/gG5k=;
        b=Evn4CpWypLC/2eEKZweFOSUmlmWxaD3Rq+fmrdi/22TT5NDF28vK6hgExFeus2C7de+zC/
        biVhUCa/e1kPebAg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id A200913592;
        Fri, 10 Mar 2023 12:05:45 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id v6gMJBkdC2SXEgAAMHmgww
        (envelope-from <lhenriques@suse.de>); Fri, 10 Mar 2023 12:05:45 +0000
Received: from localhost (brahms.olymp [local])
        by brahms.olymp (OpenSMTPD) with ESMTPA id c14305a8;
        Fri, 10 Mar 2023 12:05:42 +0000 (UTC)
From:   =?utf-8?Q?Lu=C3=ADs_Henriques?= <lhenriques@suse.de>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Xiubo Li <xiubli@redhat.com>, Jeff Layton <jlayton@kernel.org>,
        "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>,
        linux-fscrypt@vger.kernel.org, ceph-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 1/2] fscrypt: new helper function -
 __fscrypt_prepare_atomic_open()
References: <20230309121910.18939-1-lhenriques@suse.de>
        <20230309121910.18939-2-lhenriques@suse.de>
        <ZAokFixlHwav4oio@sol.localdomain>
Date:   Fri, 10 Mar 2023 12:05:42 +0000
In-Reply-To: <ZAokFixlHwav4oio@sol.localdomain> (Eric Biggers's message of
        "Thu, 9 Mar 2023 10:23:18 -0800")
Message-ID: <87mt4k6cbt.fsf@suse.de>
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

Eric Biggers <ebiggers@kernel.org> writes:

> On Thu, Mar 09, 2023 at 12:19:09PM +0000, Lu=C3=ADs Henriques wrote:
>> This patch introduces a new helper function which prepares an atomic_ope=
n.
>> Because atomic open can act as a lookup if handed a dentry that is negat=
ive,
>> we need to set DCACHE_NOKEY_NAME if the key for the parent isn't availab=
le.
>>=20
>> The reason for getting the encryption info before checking if the direct=
ory
>> has the encryption key is because we may have the key available but the
>> encryption info isn't yet set (maybe due to a drop_caches).  The regular
>> open path will use fscrypt_file_open for that but in the atomic open a
>> different approach is required.
>>=20
>> Signed-off-by: Lu=C3=ADs Henriques <lhenriques@suse.de>
>> ---
>>  fs/crypto/hooks.c       | 14 ++++++++++++++
>>  include/linux/fscrypt.h |  6 ++++++
>>  2 files changed, 20 insertions(+)
>>=20
>> diff --git a/fs/crypto/hooks.c b/fs/crypto/hooks.c
>> index 7b8c5a1104b5..cbb828ecc5eb 100644
>> --- a/fs/crypto/hooks.c
>> +++ b/fs/crypto/hooks.c
>> @@ -117,6 +117,20 @@ int __fscrypt_prepare_readdir(struct inode *dir)
>>  }
>>  EXPORT_SYMBOL_GPL(__fscrypt_prepare_readdir);
>>=20=20
>> +int __fscrypt_prepare_atomic_open(struct inode *dir, struct dentry *den=
try)
>
> Anything exported to filesystems should have a kerneldoc comment.  That w=
ould be
> a good place to put some of the explanation that you currently have only =
in the
> commit message.
>
> Also, double-underscored functions are not for use by filesystems directl=
y.
> Normally the pattern would be to make fscrypt_prepare_atomic_open() an in=
line
> function that checks IS_ENCRYPTED() and calls an out-of-line function
> __fscrypt_prepare_atomic_open().  But if it happens to be simpler to make=
 the
> caller handle the IS_ENCRYPTED() check in this case, then there should si=
mply be
> one function: fscrypt_prepare_atomic_open() (no leading underscores).

Thank you, Eric.  I'll make sure that next rev will take these comments
into account.  It definitely makes sense to move (or duplicate) the
details as a kerneldoc comment.

>> +{
>> +	int err =3D fscrypt_get_encryption_info(dir, true);
>> +
>> +	if (err || (!err && !fscrypt_has_encryption_key(dir))) {
>> +		spin_lock(&dentry->d_lock);
>> +		dentry->d_flags |=3D DCACHE_NOKEY_NAME;
>> +		spin_unlock(&dentry->d_lock);
>> +	}
>
> Why does DCACHE_NOKEY_NAME need to be set on error?
>=20
> Also note that the '!err &&' part has no effect.

To be honest, I wasn't really sure that if the d_flags should be set on
error either.  I'll drop that, and then the 'if' statement will make more
sense without the '||'.

Cheers
--=20
Lu=C3=ADs
