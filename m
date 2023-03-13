Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0A4E6B80F5
	for <lists+linux-fscrypt@lfdr.de>; Mon, 13 Mar 2023 19:43:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231410AbjCMSnp (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 13 Mar 2023 14:43:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231444AbjCMSnf (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 13 Mar 2023 14:43:35 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7350E4690;
        Mon, 13 Mar 2023 11:43:05 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id BD8571FE20;
        Mon, 13 Mar 2023 18:42:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1678732922; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rMJlqhaISa1Ka370dwVQWlVRsEJ6FnP3SqL8JT+L0hA=;
        b=LNzSGo5VjcpBDWZvjVzIRCkHhEcUXjrDXh6Bkcw7Py8jG1RmUjAh+/o0s58pOgRub7NNTt
        nGe1hadxaxroV9pM8tRmUrtr524Vqz5ymbWGz0OIyv+k/dUh6gjhQ7yCaocMHT8K7H7HsW
        thEW8Wo+hq4lVzC8JMEo2y3+FSCSJdk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1678732922;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rMJlqhaISa1Ka370dwVQWlVRsEJ6FnP3SqL8JT+L0hA=;
        b=hV9jIB1rIMNbG6ITv0ESWYWRGbWdR/ZMabhNZYRhYZzw/tiS7bdtwwjNiFcbICV6pywDLx
        Zhudx5nTz3VvpSDg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 2CB2A13517;
        Mon, 13 Mar 2023 18:42:02 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id MrTMB3puD2TrVwAAMHmgww
        (envelope-from <lhenriques@suse.de>); Mon, 13 Mar 2023 18:42:02 +0000
Received: from localhost (brahms.olymp [local])
        by brahms.olymp (OpenSMTPD) with ESMTPA id c07cb9bc;
        Mon, 13 Mar 2023 18:42:01 +0000 (UTC)
From:   =?utf-8?Q?Lu=C3=ADs_Henriques?= <lhenriques@suse.de>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Xiubo Li <xiubli@redhat.com>, Jeff Layton <jlayton@kernel.org>,
        "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>,
        linux-fscrypt@vger.kernel.org, ceph-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] ceph: switch atomic open to use new fscrypt helper
References: <20230313123310.13040-1-lhenriques@suse.de>
        <20230313123310.13040-3-lhenriques@suse.de>
        <ZA9nPXNpBX0U5joC@sol.localdomain>
Date:   Mon, 13 Mar 2023 18:42:01 +0000
In-Reply-To: <ZA9nPXNpBX0U5joC@sol.localdomain> (Eric Biggers's message of
        "Mon, 13 Mar 2023 11:11:09 -0700")
Message-ID: <87cz5cv6h2.fsf@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Eric Biggers <ebiggers@kernel.org> writes:

> On Mon, Mar 13, 2023 at 12:33:10PM +0000, Lu=C3=ADs Henriques wrote:
>> Switch ceph atomic open to use fscrypt_prepare_atomic_open().  This fixes
>> a bug where a dentry is incorrectly set with DCACHE_NOKEY_NAME when 'dir'
>> has been evicted but the key is still available (for example, where ther=
e's
>> a drop_caches).
>>=20
>> Signed-off-by: Lu=C3=ADs Henriques <lhenriques@suse.de>
>> ---
>>  fs/ceph/file.c | 8 +++-----
>>  1 file changed, 3 insertions(+), 5 deletions(-)
>>=20
>> diff --git a/fs/ceph/file.c b/fs/ceph/file.c
>> index dee3b445f415..5ad57cc4c13b 100644
>> --- a/fs/ceph/file.c
>> +++ b/fs/ceph/file.c
>> @@ -795,11 +795,9 @@ int ceph_atomic_open(struct inode *dir, struct dent=
ry *dentry,
>>  	ihold(dir);
>>  	if (IS_ENCRYPTED(dir)) {
>>  		set_bit(CEPH_MDS_R_FSCRYPT_FILE, &req->r_req_flags);
>> -		if (!fscrypt_has_encryption_key(dir)) {
>> -			spin_lock(&dentry->d_lock);
>> -			dentry->d_flags |=3D DCACHE_NOKEY_NAME;
>> -			spin_unlock(&dentry->d_lock);
>> -		}
>> +		err =3D fscrypt_prepare_atomic_open(dir, dentry);
>> +		if (err)
>> +			goto out_req;
>
> Note that this patch does not apply to upstream or even to linux-next.

True, I should have mentioned that in the cover-letter.  This patch should
be applied against the 'testing' branch in https://github.com/ceph/ceph-cli=
ent,
which is where the ceph fscrypt currently lives.

> I'd be glad to take patch 1 through the fscrypt tree for 6.4.  But I'm wo=
ndering
> what the current plans are for getting ceph's fscrypt support upstream?

As far as I know, the current plan is to try to merge the ceph code during
the next merge window for 6.4 (but Xiubo and Ilya may correct me if I'm
wrong).  Also, regarding who picks which patch, I'm fine with you picking
the first one.  But I'll let the ceph maintainers say what they think,
because it may be easier for them to keep both patches together due to the
testing infrastructure being used.

Anyway, I'll send out a new rev tomorrow taking your comments into
account.  Thanks, Eric!

Cheers,
--=20
Lu=C3=ADs
