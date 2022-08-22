Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B53059BFD3
	for <lists+linux-fscrypt@lfdr.de>; Mon, 22 Aug 2022 14:55:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232958AbiHVMzS (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 22 Aug 2022 08:55:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232195AbiHVMzQ (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 22 Aug 2022 08:55:16 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B543DF04;
        Mon, 22 Aug 2022 05:55:15 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id DE8471FFF2;
        Mon, 22 Aug 2022 12:55:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1661172913;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=4SzcUY4wM0IXoQYYr0JNf2r1R0fFfPlNFUy34e5If4s=;
        b=0eF+FdzKTdIZYIRmNlgikotnAvs5WjAaJTS0+VI4Lgfnwfts78NgYmqXtZFyLW8n2irnaz
        LusDtaiD7hi4BM0+KbcvNlzcL9G0IcEy4H8XHeSMOKkD3VqhVt9s/W1EAFTxrSP1neufWt
        6pTQ0bCKIJpgHTZZkZzUrPDvQu5BD9k=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1661172913;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=4SzcUY4wM0IXoQYYr0JNf2r1R0fFfPlNFUy34e5If4s=;
        b=Ptz/Y/YBe66zfDODfdurNrRJN9xTupzRtUn6Oty7OeI6oIUs7AKsqahu1qVr4NA48kFUXU
        HJwz8oWJ2cZErAAQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id AF13E1332D;
        Mon, 22 Aug 2022 12:55:13 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 5kB1KbF8A2PcVAAAMHmgww
        (envelope-from <dsterba@suse.cz>); Mon, 22 Aug 2022 12:55:13 +0000
Date:   Mon, 22 Aug 2022 14:50:00 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Boris Burkov <boris@bur.io>
Cc:     dsterba@suse.cz, linux-btrfs@vger.kernel.org, kernel-team@fb.com,
        linux-fscrypt@vger.kernel.org
Subject: Re: [PATCH v4] btrfs: send: add support for fs-verity
Message-ID: <20220822125000.GU13489@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Boris Burkov <boris@bur.io>,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com,
        linux-fscrypt@vger.kernel.org
References: <0561e8a33f991fa15053054b7b089d176fde6523.1660596577.git.boris@bur.io>
 <20220818173254.GN13489@twin.jikos.cz>
 <Yv6JvbDZDL/5/7Y6@zen>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yv6JvbDZDL/5/7Y6@zen>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Thu, Aug 18, 2022 at 11:49:33AM -0700, Boris Burkov wrote:
> On Thu, Aug 18, 2022 at 07:32:54PM +0200, David Sterba wrote:
> > On Mon, Aug 15, 2022 at 01:54:28PM -0700, Boris Burkov wrote:
> > > Preserve the fs-verity status of a btrfs file across send/recv.
> > > 
> > > There is no facility for installing the Merkle tree contents directly on
> > > the receiving filesystem, so we package up the parameters used to enable
> > > verity found in the verity descriptor. This gives the receive side
> > > enough information to properly enable verity again. Note that this means
> > > that receive will have to re-compute the whole Merkle tree, similar to
> > > how compression worked before encoded_write.
> > > 
> > > Since the file becomes read-only after verity is enabled, it is
> > > important that verity is added to the send stream after any file writes.
> > > Therefore, when we process a verity item, merely note that it happened,
> > > then actually create the command in the send stream during
> > > 'finish_inode_if_needed'.
> > > 
> > > This also creates V3 of the send stream format, without any format
> > > changes besides adding the new commands and attributes.
> > > 
> > > Signed-off-by: Boris Burkov <boris@bur.io>
> > 
> > As for the merge target, a realistic one seems to be 6.2, we have too
> > many pending patches everywhere else. There's a todo list for v3 that
> > I'd really like to get done.
> > 
> > To be able to test things incrementally until then we can add v3 support
> > under debug config.
> 
> That all sounds good and reasonable to me. Would you like me to re-send
> with gating V3 behind debug, or will you do it as part of taking it?

Please send a separate patch for that.

> Also, this just popped in my head, but could we acheive what we want
> with the "--proto" feature of the send CLI, and having a notion of a
> provisional version that is not yet hardened and properly named/fixed
> for future compatibility? For extra fanciness, we can do sub-versions
> or hashes of the commands or something. Maybe proto=(u64)-1 means
> experimental.

This could be usefor for some cases but I think not for the protocol,
the version is linear and we want to batch the changes into one
version. Othewise it creates dependency and configuration
complications, and users don't always listen to the "this is still
experimental" should it be meant to be outside of the debug build.
