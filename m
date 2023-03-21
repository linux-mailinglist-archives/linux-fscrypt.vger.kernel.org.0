Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5798F6C314E
	for <lists+linux-fscrypt@lfdr.de>; Tue, 21 Mar 2023 13:14:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231168AbjCUMOB (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 21 Mar 2023 08:14:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229934AbjCUMOA (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 21 Mar 2023 08:14:00 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 822FF5592;
        Tue, 21 Mar 2023 05:13:59 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 2F46F1FFA8;
        Tue, 21 Mar 2023 12:13:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1679400838; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6lqhh3x0dmFCypkdpURPj2W+m106HV2LQcy5G8mRAK0=;
        b=PZ8Idz6ywkPiqiQGG+J23CZQtRAvF8uy3vAshw3loEv3tjn75V1J89faFH+9KxtyV9wFA/
        UaeW1poI9Wv9VOFYg6ZezMcUQcAJTgGkFOX77zwUBmmuSWW6K/ePRcY8z4jcV/htfD4AfW
        V2jAhDbPDuK8VkxDfmam+9in5j176Bg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1679400838;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6lqhh3x0dmFCypkdpURPj2W+m106HV2LQcy5G8mRAK0=;
        b=Kt2x2mwa1a9RzgKQFjlgWk5S2czUJZhD6SUyfc9WXJc5FTIiEIHLjO8i8EgN/WfN7FrOI+
        Bbvg1G3XNuQvAfCQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 9B58813440;
        Tue, 21 Mar 2023 12:13:57 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id AtIKI4WfGWR3MQAAMHmgww
        (envelope-from <lhenriques@suse.de>); Tue, 21 Mar 2023 12:13:57 +0000
Received: from localhost (brahms.olymp [local])
        by brahms.olymp (OpenSMTPD) with ESMTPA id 8fadaac7;
        Tue, 21 Mar 2023 12:13:56 +0000 (UTC)
From:   =?utf-8?Q?Lu=C3=ADs_Henriques?= <lhenriques@suse.de>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Xiubo Li <xiubli@redhat.com>, Ilya Dryomov <idryomov@gmail.com>,
        Jeff Layton <jlayton@kernel.org>,
        "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        linux-fscrypt@vger.kernel.org, ceph-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/3] ceph: fscrypt: fix atomic open bug for encrypted
 directories
References: <20230316181413.26916-1-lhenriques@suse.de>
        <568da52f-18a6-5f96-cd51-5b07dedefb2d@redhat.com>
        <CAOi1vP9QsbSUq9JNRcpQpV3XWM2Eurhk+6AkDDNmks5PLTx3YQ@mail.gmail.com>
        <0b51da52-bb38-2094-b9b2-bc3858066be5@redhat.com>
        <20230320221609.GA21979@sol.localdomain>
Date:   Tue, 21 Mar 2023 12:13:56 +0000
In-Reply-To: <20230320221609.GA21979@sol.localdomain> (Eric Biggers's message
        of "Mon, 20 Mar 2023 15:16:09 -0700")
Message-ID: <87v8iugv3v.fsf@suse.de>
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

> On Mon, Mar 20, 2023 at 08:47:18PM +0800, Xiubo Li wrote:
>>=20
>> On 20/03/2023 19:20, Ilya Dryomov wrote:
>> > On Mon, Mar 20, 2023 at 2:07=E2=80=AFAM Xiubo Li <xiubli@redhat.com> w=
rote:
>> > >=20
>> > > On 17/03/2023 02:14, Lu=C3=ADs Henriques wrote:
>> > > > Hi!
>> > > >=20
>> > > > I started seeing fstest generic/123 failing in ceph fscrypt, when =
running it
>> > > > with 'test_dummy_encryption'.  This test is quite simple:
>> > > >=20
>> > > > 1. Creates a directory with write permissions for root only
>> > > > 2. Writes into a file in that directory
>> > > > 3. Uses 'su' to try to modify that file as a different user, and
>> > > >      gets -EPERM
>> > > >=20
>> > > > All the test steps succeed, but the test fails to cleanup: 'rm -rf=
 <dir>'
>> > > > will fail with -ENOTEMPTY.  'strace' shows that calling unlinkat()=
 to remove
>> > > > the file got a -ENOENT and then -ENOTEMPTY for the directory.
>> > > >=20
>> > > > This is because 'su' does a drop_caches ('su (874): drop_caches: 2=
' in
>> > > > dmesg), and ceph's atomic open will do:
>> > > >=20
>> > > >        if (IS_ENCRYPTED(dir)) {
>> > > >                set_bit(CEPH_MDS_R_FSCRYPT_FILE, &req->r_req_flags);
>> > > >                if (!fscrypt_has_encryption_key(dir)) {
>> > > >                        spin_lock(&dentry->d_lock);
>> > > >                        dentry->d_flags |=3D DCACHE_NOKEY_NAME;
>> > > >                        spin_unlock(&dentry->d_lock);
>> > > >                }
>> > > >        }
>> > > >=20
>> > > > Although 'dir' has the encryption key available, fscrypt_has_encry=
ption_key()
>> > > > will return 'false' because fscrypt info isn't yet set after the c=
ache
>> > > > cleanup.
>> > > >=20
>> > > > The first patch will add a new helper for the atomic_open that wil=
l force
>> > > > the fscrypt info to be loaded into an inode that has been evicted =
recently
>> > > > but for which the key is still available.
>> > > >=20
>> > > > The second patch switches ceph atomic_open to use the new fscrypt =
helper.
>> > > >=20
>> > > > Cheers,
>> > > > --
>> > > > Lu=C3=ADs
>> > > >=20
>> > > > Changes since v2:
>> > > > - Make helper more generic and to be used both in lookup and atomi=
c open
>> > > >     operations
>> > > > - Modify ceph_lookup (patch 0002) and ceph_atomic_open (patch 0003=
) to use
>> > > >     the new helper
>> > > >=20
>> > > > Changes since v1:
>> > > > - Dropped IS_ENCRYPTED() from helper function because kerneldoc sa=
ys
>> > > >     already that it applies to encrypted directories and, most imp=
ortantly,
>> > > >     because it would introduce a different behaviour for
>> > > >     CONFIG_FS_ENCRYPTION and !CONFIG_FS_ENCRYPTION.
>> > > > - Rephrased helper kerneldoc
>> > > >=20
>> > > > Changes since initial RFC (after Eric's review):
>> > > > - Added kerneldoc comments to the new fscrypt helper
>> > > > - Dropped '__' from helper name (now fscrypt_prepare_atomic_open())
>> > > > - Added IS_ENCRYPTED() check in helper
>> > > > - DCACHE_NOKEY_NAME is not set if fscrypt_get_encryption_info() re=
turns an
>> > > >     error
>> > > > - Fixed helper for !CONFIG_FS_ENCRYPTION (now defined 'static inli=
ne')
>> > > This series looks good to me.
>> > >=20
>> > > And I have run the test locally and worked well.
>> > >=20
>> > >=20
>> > > > Lu=C3=ADs Henriques (3):
>> > > >     fscrypt: new helper function - fscrypt_prepare_lookup_partial()
>> > > Eric,
>> > >=20
>> > > If possible I we can pick this together to ceph repo and need your a=
ck
>> > > about this. Or you can pick it to the crypto repo then please feel f=
ree
>> > > to add:
>> > >=20
>> > > Tested-by: Xiubo Li <xiubli@redhat.com> and Reviewed-by: Xiubo Li
>> > > <xiubli@redhat.com>
>> > I would prefer the fscrypt helper to go through the fscrypt tree.
>>=20
>> Sure. This also LGTM.
>>=20
>> Thanks
>>=20
>
> I've applied it to
> https://git.kernel.org/pub/scm/fs/fscrypt/linux.git/log/?h=3Dfor-next
>
> But I ended up reworking the comment a bit and moving the function to be =
just
> below __fscrypt_prepare_lookup().  So I sent out v4 that matches what I a=
pplied.

Awesome, thanks a lot, Eric.

> BTW, I'm wondering if anyone has had any thoughts about the race conditio=
n I
> described at https://lore.kernel.org/r/ZBC1P4Gn6eAKD61+@sol.localdomain/.=
  In
> particular, I'm wondering whether this helper function will need to be ch=
anged
> or not.  Maybe not, because ceph could look at DCACHE_NOKEY_NAME to deter=
mine
> whether the name should be treated as a no-key name or not, instead of ch=
ecking
> fscrypt_has_encryption_key() again (as I think it is doing currently)?

I started looking into that but, to be honest, I haven't yet reached any
conclusion.  It looks like the ceph code that handles filenames *may* have
this race too (I'm looking at ceph_fill_trace()) but I'm still not 100%
sure.  In any case, I think that an eventual fix for this race (if it does
indeed exist!) will likely be restricted to the ceph code and won't touch
the generic fscrypt code.  But I'm still looking...

Cheers,
--=20
Lu=C3=ADs
