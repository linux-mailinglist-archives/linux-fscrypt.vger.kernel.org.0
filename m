Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8D327576B5
	for <lists+linux-fscrypt@lfdr.de>; Tue, 18 Jul 2023 10:36:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231818AbjGRIgg (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 18 Jul 2023 04:36:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231822AbjGRIgf (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 18 Jul 2023 04:36:35 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A23D710C2;
        Tue, 18 Jul 2023 01:36:28 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 498501F461;
        Tue, 18 Jul 2023 08:36:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1689669387; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SSAu38CW1d1eLowCNyzjcETntGZuvQ0buyFU2sTfn7Y=;
        b=nZIPnKJqn3Pn8Zz6mK/MJzja0IHTr8LywXTnkk4koEDNokWcgW6gPpRXA6iVDb+L+GlOTe
        lYA8g4KbF8iyZ71k8JcVWgdEAvPqoUvxCjEjksvpqr3RZGzUV4IVAynHVfRcU/XbfES1Z9
        ljBxQ6/Qg7o6EIZ5EHwmRxb9hRCRAVk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1689669387;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SSAu38CW1d1eLowCNyzjcETntGZuvQ0buyFU2sTfn7Y=;
        b=n65R9MQXjJ6I2/PkbOaAb/C+W47S6f0l/coL5dJoQ/gVMTvCGFnh7mkNmDskeF7YE+5ylL
        Rf8m6M18B1FIaMDw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 8D8EB13494;
        Tue, 18 Jul 2023 08:36:26 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id t/mUHwpPtmT4RwAAMHmgww
        (envelope-from <lhenriques@suse.de>); Tue, 18 Jul 2023 08:36:26 +0000
Received: from localhost (brahms.olymp [local])
        by brahms.olymp (OpenSMTPD) with ESMTPA id 3e9b9fc6;
        Tue, 18 Jul 2023 08:36:26 +0000 (UTC)
From:   =?utf-8?Q?Lu=C3=ADs_Henriques?= <lhenriques@suse.de>
To:     David Sterba <dsterba@suse.cz>
Cc:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>,
        "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@meta.com,
        Omar Sandoval <osandov@osandov.com>
Subject: Re: [PATCH v2 04/17] btrfs: start using fscrypt hooks
References: <cover.1689564024.git.sweettea-kernel@dorminy.me>
        <0afc75247f4312d78ce663382e7d89854c353e9b.1689564024.git.sweettea-kernel@dorminy.me>
        <875y6iwnsr.fsf@suse.de> <20230717172823.GK20457@suse.cz>
Date:   Tue, 18 Jul 2023 09:36:26 +0100
In-Reply-To: <20230717172823.GK20457@suse.cz> (David Sterba's message of "Mon,
        17 Jul 2023 19:28:23 +0200")
Message-ID: <87sf9lvcol.fsf@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

David Sterba <dsterba@suse.cz> writes:

> On Mon, Jul 17, 2023 at 04:34:17PM +0100, Lu=C3=ADs Henriques wrote:
>> (Sorry for the send.  Somehow, my MUA is failing to set the CC header.)
>> Sweet Tea Dorminy <sweettea-kernel@dorminy.me> writes:
>> > --- a/fs/btrfs/file.c
>> > +++ b/fs/btrfs/file.c
>> > @@ -3698,6 +3698,9 @@ static int btrfs_file_open(struct inode *inode, =
struct file *filp)
>> >=20=20
>> >  	filp->f_mode |=3D FMODE_NOWAIT | FMODE_BUF_RASYNC | FMODE_BUF_WASYNC=
 |
>> >  		        FMODE_CAN_ODIRECT;
>> > +	ret =3D fscrypt_file_open(inode, filp);
>> > +	if (ret)
>> > +		return ret;
>> >=20=20
>> >  	ret =3D fsverity_file_open(inode, filp);
>> >  	if (ret)
>> > diff --git a/fs/btrfs/fscrypt.c b/fs/btrfs/fscrypt.c
>>=20
>> Nit: both ext4 and ubifs (and in a (hopefully!) near future, ceph) use
>> 'crypto.c' for naming this file.  I'd prefer consistency, but meh.
>
> I'm still not decied if we should all crypto as plain crypto or
> distinguish the backends, where fscrypt is one of them and a proposed
> one by a different name. The difference is the depth of the subvolume
> support, fscrypt is on the level of files and directories, the subvolume
> level and snapshots can be grouped in another way.

OK, it then makes sense to use this filename instead.  Thanks for
clarifying, David.

Cheers,
--=20
Lu=C3=ADs
