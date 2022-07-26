Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D01C581905
	for <lists+linux-fscrypt@lfdr.de>; Tue, 26 Jul 2022 19:51:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239751AbiGZRu5 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 26 Jul 2022 13:50:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239721AbiGZRur (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 26 Jul 2022 13:50:47 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D96DF3057A;
        Tue, 26 Jul 2022 10:50:37 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 877551FD3A;
        Tue, 26 Jul 2022 17:50:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1658857836;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Gm3qnLAYsQBIJg426MOfCKsmEjrCPUPylpVnraWZmIk=;
        b=LDBU8gKgoo1l96qIbktk1EUfEiOplxBi8RV2e7Z3+1YKXJv/7pCbHCD9SRRbohZy/x/wcA
        ArDeymHiF7sZYafmErRqNys1oObbrts2B7WLaPBDRNE5wixznl7tW1oPeY/EavHQ/aW8yJ
        yt4N6UYFtk35HTJaPxX3zGb9Xi4Jz1I=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1658857836;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Gm3qnLAYsQBIJg426MOfCKsmEjrCPUPylpVnraWZmIk=;
        b=BEv2XYQ854Yzij2xKUKWIEW4EH/0gSle8nB3lrXt2iAE6R933kxRwF7nqzwy9EOWiWFuxk
        glCc6/XiVx22obBw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 3945813A7C;
        Tue, 26 Jul 2022 17:50:36 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id gTftDGwp4GIVDgAAMHmgww
        (envelope-from <dsterba@suse.cz>); Tue, 26 Jul 2022 17:50:36 +0000
Date:   Tue, 26 Jul 2022 19:45:38 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Cc:     Eric Biggers <ebiggers@kernel.org>,
        "Theodore Y . Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        linux-fscrypt@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-btrfs@vger.kernel.org, osandov@osandov.com,
        kernel-team@fb.com
Subject: Re: [PATCH RFC 4/4] fscrypt: Add new encryption policy for btrfs.
Message-ID: <20220726174538.GG13489@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz,
        Sweet Tea Dorminy <sweettea-kernel@dorminy.me>,
        Eric Biggers <ebiggers@kernel.org>,
        "Theodore Y . Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>, linux-fscrypt@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org,
        osandov@osandov.com, kernel-team@fb.com
References: <cover.1658623235.git.sweettea-kernel@dorminy.me>
 <675dd03f1a4498b09925fbf93cc38b8430cb7a59.1658623235.git.sweettea-kernel@dorminy.me>
 <Yt8oEiN6AkglKfIc@sol.localdomain>
 <7130dd3f-202c-2e70-c37f-57be9b85548b@dorminy.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7130dd3f-202c-2e70-c37f-57be9b85548b@dorminy.me>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Mon, Jul 25, 2022 at 10:16:07PM -0400, Sweet Tea Dorminy wrote:
> On 7/25/22 19:32, Eric Biggers wrote:
> > On Sat, Jul 23, 2022 at 08:52:28PM -0400, Sweet Tea Dorminy wrote:

> > Given that this new proposal uses per-block metadata, has
> > support for authenticated encryption been considered? Has space been reserved
> > in the per-block metadata for authentication tags so that authenticated
> > encryption support could be added later even if it's not in the initial version?
> 
> I don't know sufficiently much about authenticated encryption to have 
> considered it. As currently drafted, btrfs encrypts before checksumming 
> if checksums are enabled, and checks against checksums before 
> decrypting. Although at present we haven't discussed authentication 
> tags, btrfs could store them in a separate itemtype which could be added 
> at any time, much as we currently store fsverity data. We do have 
> sufficient room saved for adding other encryption types, if necessary; 
> we could use some of that to indicate the existence of authentication 
> tags for the extents' data.

The AEAD tag can be used in place of checksum (also stored in the
checksum item).
