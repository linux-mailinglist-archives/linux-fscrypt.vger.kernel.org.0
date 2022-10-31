Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C83C6613A6C
	for <lists+linux-fscrypt@lfdr.de>; Mon, 31 Oct 2022 16:43:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231913AbiJaPnO (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 31 Oct 2022 11:43:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231696AbiJaPnN (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 31 Oct 2022 11:43:13 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A0DF647E;
        Mon, 31 Oct 2022 08:43:13 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id ED8B0338D0;
        Mon, 31 Oct 2022 15:43:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1667230991;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Ix9Bo9uEbCIdVgnFN29TRHNvddRhh0o/NHtghNevVwU=;
        b=ayobSNdfhBzCiOoROqdUmhNXvknFgxGU42wSMVy/F4SOr2Nc68OT/WnzYiNfkq8/Yub1TT
        ikN52jEecaAc/1au03GRJPMa+cnSyPLOMnCr2eVoSsrYJSCIH4iQXpFI2dvdYdeJD9362x
        g8oxBoysiL7eF2fsIQ+LII6RzDwAkPo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1667230991;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Ix9Bo9uEbCIdVgnFN29TRHNvddRhh0o/NHtghNevVwU=;
        b=dDeHkF7VmAF+HMgF7uGUQEGD2MEdZjj8lzlZJuUf56g37ty4lkcUHjOCQI3YYi9k5HPKUi
        4M9yXPiKbonfgKDA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id A7E7913AAD;
        Mon, 31 Oct 2022 15:43:11 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id cVccKA/tX2OkJAAAMHmgww
        (envelope-from <dsterba@suse.cz>); Mon, 31 Oct 2022 15:43:11 +0000
Date:   Mon, 31 Oct 2022 16:42:54 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Filipe Manana <fdmanana@kernel.org>
Cc:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>,
        "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH v4 08/21] btrfs: setup qstrings from dentrys using
 fscrypt helper
Message-ID: <20221031154254.GC5824@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1666651724.git.sweettea-kernel@dorminy.me>
 <0bc4b89f82d49a12a2d33777824afde9dac80985.1666651724.git.sweettea-kernel@dorminy.me>
 <CAL3q7H7_0FmVwP32P6vJsrRb6rdVze=OLV7jHBucpnc7NfGP1w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAL3q7H7_0FmVwP32P6vJsrRb6rdVze=OLV7jHBucpnc7NfGP1w@mail.gmail.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Tue, Oct 25, 2022 at 02:14:49PM +0100, Filipe Manana wrote:
> On Tue, Oct 25, 2022 at 2:29 AM Sweet Tea Dorminy
> <sweettea-kernel@dorminy.me> wrote:
> > @@ -5523,7 +5560,7 @@ void btrfs_evict_inode(struct inode *inode)
> >
> >  /*
> >   * Return the key found in the dir entry in the location pointer, fill @type
> > - * with BTRFS_FT_*, and return 0.
> > + * with BTRFS_FT_*, and return 0. Used only for lookups, not removals.
> 
> This is a bit confusing. What removals?
> Isn't it clear the function is used only for lookups?

Agreed, update removed.

> 
> >   *
> >   * If no dir entries were found, returns -ENOENT.
> >   * If found a corrupted location in dir entry, returns -EUCLEAN.
> > @@ -5531,18 +5568,27 @@ void btrfs_evict_inode(struct inode *inode)

> > @@ -1630,9 +1633,23 @@ static noinline int create_pending_snapshot(struct btrfs_trans_handle *trans,
> >         ASSERT(pending->root_item);
> >         new_root_item = pending->root_item;
> >
> > +       /*
> > +        * Since this is during btrfs_commit_transaction() and more items
> > +        * joining the transaction at this point would be bad, use NOFS
> > +        * allocations so that no new writes are kicked off.
> > +        */
> 
> This comment makes no sense to me.
> 
> The reason we have to use NOFS it's because when a memory allocation
> triggers reclaim it may recurse into the filesystem and
> trigger transaction start/join/attach, which would result in a
> deadlock (see below why exactly).
> 
> The "more items joining the transaction at this point would be bad"
> makes no sense because it's simply not possible.
> At this point the transaction is in the state
> TRANS_STATE_COMMIT_DOING, so no one can join it and use it for further
> modifying the fs - anyone trying to start a new transaction, join or
> attach this one will block until the transaction state
> becomes >= TRANS_STATE_UNBLOCKED and after that it will have to start
> a new transaction (can't reuse the former).

I've updated the commit so it says why whe need the NOFS protection
similar to what we have elsewhere. There's one GFP_KERNEL allocation in
fscrypt_setup_filename so the protection is needed.
