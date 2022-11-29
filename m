Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4413E63B94B
	for <lists+linux-fscrypt@lfdr.de>; Tue, 29 Nov 2022 06:06:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232539AbiK2FGU (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 29 Nov 2022 00:06:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbiK2FGT (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 29 Nov 2022 00:06:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FD1F4875D;
        Mon, 28 Nov 2022 21:06:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1AC9A61550;
        Tue, 29 Nov 2022 05:06:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D8D7C433D6;
        Tue, 29 Nov 2022 05:06:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669698377;
        bh=JTgpHjAuSpjt608/g3FhluibjmOwGlNM5fhbL804p3U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LNmPAt2m3DD4mFw2WvJL85fhHuribqVKh+dRo6b/RYN/T72kkAfKUlKvoQuZTKT0V
         TfbpVYHywMZ/YBr3WYRHNn03+8RnZiu/QdUqYdWB2oGKFBiVnjZbRBacIocoiFcvpL
         MnLWELd22VZWo4rVlN+KJGu5Qe/3KJjt5od35WBOdx+6fXze8y0hv8mUmkNGrMJ4Ep
         5z9ZzfDv+0IkLg+vEVKeT1hJ3DzVA/OCUaWQ0BGITZYtVGBOFiJSaPvX2ZfzIHXIg5
         ComqD2N5X7dGgWYjQlqHfn5XmDB2bHQ+4s4CwYHkO12ZzSbxl3u8L0c3qxJ5TLl9eP
         QRnrY6iwerbrA==
Date:   Mon, 28 Nov 2022 21:06:15 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org
Cc:     Mimi Zohar <zohar@linux.ibm.com>, linux-integrity@vger.kernel.org
Subject: Re: [PATCH] fsverity: simplify fsverity_get_digest()
Message-ID: <Y4WTRyaxqfjVdId4@sol.localdomain>
References: <20221129045139.69803-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221129045139.69803-1-ebiggers@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Mon, Nov 28, 2022 at 08:51:39PM -0800, Eric Biggers wrote:
> Verify at build time that every fsverity_hash_alg has a valid
> hash_algo ID with matching digest size.

Sorry, this should say "boot time".

- Eric
