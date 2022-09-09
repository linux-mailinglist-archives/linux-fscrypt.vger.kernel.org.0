Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B7045B368C
	for <lists+linux-fscrypt@lfdr.de>; Fri,  9 Sep 2022 13:41:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229897AbiIILlH (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 9 Sep 2022 07:41:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231386AbiIILku (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 9 Sep 2022 07:40:50 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB99AB7C0;
        Fri,  9 Sep 2022 04:40:39 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 3D9D01F38D;
        Fri,  9 Sep 2022 11:40:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1662723637;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Y2/ApC+/9+tbBTQ4C0gDPcs0Yxwi7OTIvyx1XOfxGRc=;
        b=n61oAypWpzU/CGOZunPwPRCHLUgKP2pSSCsl4LaZawY0HKZSiAeP4IwLCIPPGCXCoXN2ft
        w/gD6acmM9JGU03X4MHxk9fd0kdHZ+3HWN6apH8R1bKT1zbX2ayHmgM8M9N1bIwwN1ccnl
        gDwD7URj6QNkbdy7x+GcJT/piuWUWKw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1662723637;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Y2/ApC+/9+tbBTQ4C0gDPcs0Yxwi7OTIvyx1XOfxGRc=;
        b=l/mT6e2Ve/PQ6NVVrIodnzra8Q/3lR/EjntxoP+qXsnClpVOONN1v+CtjfBgWRpi/hln95
        C5sMfx80AFMsBYCg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id EBC7413A93;
        Fri,  9 Sep 2022 11:40:36 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id zUG2ODQmG2NpFwAAMHmgww
        (envelope-from <dsterba@suse.cz>); Fri, 09 Sep 2022 11:40:36 +0000
Date:   Fri, 9 Sep 2022 13:35:12 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Cc:     "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com,
        Omar Sandoval <osandov@osandov.com>
Subject: Re: [PATCH v2 16/20] btrfs: Add new FEATURE_INCOMPAT_FSCRYPT feature
 flag.
Message-ID: <20220909113512.GT32411@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1662420176.git.sweettea-kernel@dorminy.me>
 <dc78a8b7148d5b611008e722617310b6be941cdc.1662420176.git.sweettea-kernel@dorminy.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dc78a8b7148d5b611008e722617310b6be941cdc.1662420176.git.sweettea-kernel@dorminy.me>
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

On Mon, Sep 05, 2022 at 08:35:31PM -0400, Sweet Tea Dorminy wrote:
> From: Omar Sandoval <osandov@osandov.com>

Subject: Re: [PATCH v2 16/20] btrfs: Add new FEATURE_INCOMPAT_FSCRYPT feature flag.

And for subjects please use lower case after "btrfs: " and don't put "."
at the end of the line.
