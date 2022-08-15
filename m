Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90590593AE1
	for <lists+linux-fscrypt@lfdr.de>; Mon, 15 Aug 2022 22:34:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344188AbiHOTm5 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 15 Aug 2022 15:42:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345163AbiHOTmc (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 15 Aug 2022 15:42:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C84C6B656;
        Mon, 15 Aug 2022 11:48:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5705C61215;
        Mon, 15 Aug 2022 18:48:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8523BC433C1;
        Mon, 15 Aug 2022 18:48:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660589292;
        bh=BRy9d/5usXj2GJIlMpROcnSbw1Cf0yoIwk1b/XPjMc4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YJtN/l1qOiuCoUMD5w+crWUXQii15ha6YD/fIvcivrV+ZUQr8KZtQGJ2maAN3aMox
         CaKiPBxIq4pB8TELa5ZPNrT6Lu7PQxa8B1yJW6vvJ6kS1Jd93dOjzA/PlIRZ0la6Ap
         RvAyc1WY8j6Aut2Wr9gmugyDlGOJdS3nbFr6jGd3ON/e6craP2T+JkebO2NZzvboWe
         8UvsBRaVYmkLRLo0em43f+In/HixsqcRZcYxK8o63iTu8tu7nNphmARVnSJ0D3lh52
         bgf1u7MRtmyJs0HJr2FAQX+5fgAyuWah7NgX5btYgM0IAs9RLQaXL1sPf5jvqY13+c
         lZcHdUYS3nNjQ==
Date:   Mon, 15 Aug 2022 11:48:10 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Cc:     Lukas Czerner <lczerner@redhat.com>,
        Jeff Layton <jlayton@kernel.org>,
        Theodore Ts'o <tytso@mit.edu>, Jaegeuk Kim <jaegeuk@kernel.org>
Subject: Re: [PATCH v3 5/5] fscrypt: remove
 fscrypt_set_test_dummy_encryption()
Message-ID: <YvqU6qenlAmEg6ev@sol.localdomain>
References: <20220513231605.175121-1-ebiggers@kernel.org>
 <20220513231605.175121-6-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220513231605.175121-6-ebiggers@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Fri, May 13, 2022 at 04:16:05PM -0700, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> Now that all its callers have been converted to
> fscrypt_parse_test_dummy_encryption() and fscrypt_add_test_dummy_key()
> instead, fscrypt_set_test_dummy_encryption() can be removed.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>  fs/crypto/policy.c      | 13 -------------
>  include/linux/fscrypt.h |  2 --
>  2 files changed, 15 deletions(-)

Now that all its prerequisites are upstream, I've applied this patch to
fscrypt.git#master for 6.1.

- Eric
