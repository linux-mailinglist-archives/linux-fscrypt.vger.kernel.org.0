Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B39F756AC9
	for <lists+linux-fscrypt@lfdr.de>; Mon, 17 Jul 2023 19:35:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229701AbjGQRfq (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 17 Jul 2023 13:35:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230362AbjGQRfn (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 17 Jul 2023 13:35:43 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69007171E;
        Mon, 17 Jul 2023 10:35:20 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id C848C1FDB2;
        Mon, 17 Jul 2023 17:35:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1689615302;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Jl+DZqShe5U7Yi8+9vR4B5JapmrxWMijwJV2h/zpDgg=;
        b=gMOGkpqoqgesE+/aW/ZKLUDcLaZeBj7hxIERag0pTNyB0rHfgHGMdL3cvJROe9GXFV4MzI
        miqKmIVtnUL6PMCNXXUMzXt9/gzJHeOA2wDZCtZpnzpTWbK1JGFihGHprAaD78Uhp8LIeL
        SHOFDbeFdbRbsFA3l/w4lqPgF6i8qJk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1689615302;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Jl+DZqShe5U7Yi8+9vR4B5JapmrxWMijwJV2h/zpDgg=;
        b=B/q01OBCf4/g+G16ppZR/P31GU9sGQjWbAFNhdqImvkRJ4R8qIdzmWdvL1dqbmVAHnkSAO
        p0Le6Yceqivlw6CA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 7DB4B13276;
        Mon, 17 Jul 2023 17:35:02 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id cSvhHcZ7tWQvSQAAMHmgww
        (envelope-from <dsterba@suse.cz>); Mon, 17 Jul 2023 17:35:02 +0000
Date:   Mon, 17 Jul 2023 19:28:23 +0200
From:   David Sterba <dsterba@suse.cz>
To:     =?iso-8859-1?Q?Lu=EDs?= Henriques <lhenriques@suse.de>
Cc:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>,
        "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@meta.com,
        Omar Sandoval <osandov@osandov.com>
Subject: Re: [PATCH v2 04/17] btrfs: start using fscrypt hooks
Message-ID: <20230717172823.GK20457@suse.cz>
Reply-To: dsterba@suse.cz
References: <cover.1689564024.git.sweettea-kernel@dorminy.me>
 <0afc75247f4312d78ce663382e7d89854c353e9b.1689564024.git.sweettea-kernel@dorminy.me>
 <875y6iwnsr.fsf@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <875y6iwnsr.fsf@suse.de>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Mon, Jul 17, 2023 at 04:34:17PM +0100, Luís Henriques wrote:
> (Sorry for the send.  Somehow, my MUA is failing to set the CC header.)
> Sweet Tea Dorminy <sweettea-kernel@dorminy.me> writes:
> > --- a/fs/btrfs/file.c
> > +++ b/fs/btrfs/file.c
> > @@ -3698,6 +3698,9 @@ static int btrfs_file_open(struct inode *inode, struct file *filp)
> >  
> >  	filp->f_mode |= FMODE_NOWAIT | FMODE_BUF_RASYNC | FMODE_BUF_WASYNC |
> >  		        FMODE_CAN_ODIRECT;
> > +	ret = fscrypt_file_open(inode, filp);
> > +	if (ret)
> > +		return ret;
> >  
> >  	ret = fsverity_file_open(inode, filp);
> >  	if (ret)
> > diff --git a/fs/btrfs/fscrypt.c b/fs/btrfs/fscrypt.c
> 
> Nit: both ext4 and ubifs (and in a (hopefully!) near future, ceph) use
> 'crypto.c' for naming this file.  I'd prefer consistency, but meh.

I'm still not decied if we should all crypto as plain crypto or
distinguish the backends, where fscrypt is one of them and a proposed
one by a different name. The difference is the depth of the subvolume
support, fscrypt is on the level of files and directories, the subvolume
level and snapshots can be grouped in another way.
