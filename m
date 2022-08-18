Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E06B6597DB8
	for <lists+linux-fscrypt@lfdr.de>; Thu, 18 Aug 2022 06:57:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241159AbiHRE5a (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 18 Aug 2022 00:57:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233628AbiHRE53 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 18 Aug 2022 00:57:29 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB3AB90C4A;
        Wed, 17 Aug 2022 21:57:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 14D97CE1DF6;
        Thu, 18 Aug 2022 04:57:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAAC2C433C1;
        Thu, 18 Aug 2022 04:57:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660798644;
        bh=OfDs0cEuz1gghQvE215NZi5DyLV3jtRhyQiAm1jxW+U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ITY+0hCXUCtmF1h/a6diIGFVjv4u+uQ5kaUFkiZlmKUyCMtUXnBf5N+E2s54Eca3Y
         GGEMV8nVMGbz/CwIyA3SYgx6u1rQEyqpFfHzfEjqXCRamvVOPzxVP/VsC90LTLIWQa
         Gn60bsgTxWZyZITIyKLtFdKUatGB96AD+wd1AMxydHvAI7c+XLLoJyWh0MQULtZPPF
         LEGE0IZv0xfD0z2KajdZZUE5xjrjaSNd7N3GKFAUgSMizsFvCXI3A/qcrCpjXq58Hb
         vclB6HhGdfdLlVUobCTJ95/imVzGCS4vlzlwTK8n8d2jiVwq40xtvtVyKOviOEyk7z
         DNLqcw0Ser75A==
Date:   Wed, 17 Aug 2022 21:57:22 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Boris Burkov <boris@bur.io>
Cc:     linux-btrfs@vger.kernel.org, kernel-team@fb.com,
        linux-fscrypt@vger.kernel.org
Subject: Re: [PATCH v4] btrfs: send: add support for fs-verity
Message-ID: <Yv3GssrE8hAFzGLJ@sol.localdomain>
References: <0561e8a33f991fa15053054b7b089d176fde6523.1660596577.git.boris@bur.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0561e8a33f991fa15053054b7b089d176fde6523.1660596577.git.boris@bur.io>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Mon, Aug 15, 2022 at 01:54:28PM -0700, Boris Burkov wrote:
> diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
> index e7671afcee4f..9e8679848d54 100644
> --- a/fs/btrfs/send.c
> +++ b/fs/btrfs/send.c
> @@ -3,6 +3,7 @@
>   * Copyright (C) 2012 Alexander Block.  All rights reserved.
>   */
>  
> +#include "linux/compiler_attributes.h"

I don't understand the purpose of this include.  And why is it in quotes?

Otherwise this patch looks good to me.

- Eric
