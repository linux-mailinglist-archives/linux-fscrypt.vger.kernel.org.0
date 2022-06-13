Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9038549BA0
	for <lists+linux-fscrypt@lfdr.de>; Mon, 13 Jun 2022 20:35:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238656AbiFMSfr (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 13 Jun 2022 14:35:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245718AbiFMSfe (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 13 Jun 2022 14:35:34 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 821DE658C;
        Mon, 13 Jun 2022 08:44:29 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 3AC8221C9C;
        Mon, 13 Jun 2022 15:44:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1655135068;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=dpgW6MNoCQrDdhZ76zxC1MVQVMtxZoXmwPsCDRjhyjc=;
        b=mItY3WSujTf0FbvSXSOz1DJNP0L+bQWltXUBMXe0sm6oKJEd7ZFBSBkzXmvOykzScgU2fX
        4UPd4RHvJHRTdRo6wljDcBTA5DcNpQ4KGTwDo2v2cG+xJOH4XUGPqrD+Jh7I8n5f9kj5mf
        L5NSyEkUNTqZcGnHM2eiNDhAjwcEUsw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1655135068;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=dpgW6MNoCQrDdhZ76zxC1MVQVMtxZoXmwPsCDRjhyjc=;
        b=QTmQ8qvs3o4Pj7mwOYrPhyRWACBad69eHGn0LSH6L1mSTLz2lOOHdFdr6MFPeuUqPSF7Lu
        ZzJOJM1azzUhy8Cg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 1C478134CF;
        Mon, 13 Jun 2022 15:44:28 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 7wzXBVxbp2KXYQAAMHmgww
        (envelope-from <dsterba@suse.cz>); Mon, 13 Jun 2022 15:44:28 +0000
Date:   Mon, 13 Jun 2022 17:39:55 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-fscrypt@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] fs-verity: mention btrfs support
Message-ID: <20220613153955.GA20633@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Eric Biggers <ebiggers@kernel.org>,
        linux-fscrypt@vger.kernel.org, linux-btrfs@vger.kernel.org
References: <20220610000616.18225-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220610000616.18225-1-ebiggers@kernel.org>
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

On Thu, Jun 09, 2022 at 05:06:16PM -0700, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> btrfs supports fs-verity since Linux v5.15.  Document this.

The reworded paragraphs and the added section regarding btrfs look ok to
me, thanks. I don't see linux-doc@ in CC I think the documentation
patches should go there.

Acked-by: David Sterba <dsterba@suse.com>
