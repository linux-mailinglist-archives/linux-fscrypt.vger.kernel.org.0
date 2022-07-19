Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5E8857A76D
	for <lists+linux-fscrypt@lfdr.de>; Tue, 19 Jul 2022 21:51:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229379AbiGSTvO (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 19 Jul 2022 15:51:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229709AbiGSTvN (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 19 Jul 2022 15:51:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5355052468;
        Tue, 19 Jul 2022 12:51:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D867B618CD;
        Tue, 19 Jul 2022 19:51:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0ECEC341C6;
        Tue, 19 Jul 2022 19:51:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658260272;
        bh=OmH6BIVlWupXw9n6kyJO8g/b/Gcerl0XPhQar0T3SuQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lcC6yAe6ml1XrR+6Q1DU1EjMBIfohJshiFdmHOcWupX18oFBihemhMDbCTxndUCNK
         HPDyGleZlC1aT9HE5THgncQ90GVrGlHcg8VE0djxl9UHp4K7heeEC0sk2XlOcyyeD8
         am5BqXtnw1JXAcULZL/Axv6EunubEp5zc1VDykFXzDxqfp9kdk+0aOrQxyLKEafnQ3
         iTZJxEiD8EWgeGegKnb2eUFNcaN+WFCEqd+rG06IfnTzxTE7utqNPJCGHqu/boeaW7
         5WjsRnrW1fm0CnXs59S+6bxPbXL/nEdQg0VcR8/OTwYklcDviubepD1X8+uNASAyhK
         IMubbcuE7ePgQ==
Date:   Tue, 19 Jul 2022 12:51:10 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Nathan Huckleberry <nhuck@google.com>
Cc:     fstests@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        Sami Tolvanen <samitolvanen@google.com>
Subject: Re: [RFC PATCH v4 2/2] generic: add tests for fscrypt policies with
 HCTR2
Message-ID: <YtcLLnjm90td0lqP@sol.localdomain>
References: <20220601071811.1353635-1-nhuck@google.com>
 <20220601071811.1353635-3-nhuck@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220601071811.1353635-3-nhuck@google.com>
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Wed, Jun 01, 2022 at 12:18:11AM -0700, Nathan Huckleberry wrote:
> diff --git a/tests/generic/900 b/tests/generic/900
> new file mode 100755
> index 00000000..d1496007
> --- /dev/null
> +++ b/tests/generic/900
> @@ -0,0 +1,28 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright 2022 Google LLC
> +#
> +# FS QA Test No. generic/900
> +#
> +# Verify ciphertext for v2 encryption policies that use AES-256-XTS to encrypt
> +# file contents and AES-256-HCTR2 to encrypt file names.
> +#

How about mentioning here the commit that introduced this feature upstream?

Otherwise this patch looks good.

- Eric
