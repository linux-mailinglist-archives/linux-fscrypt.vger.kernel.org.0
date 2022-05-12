Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F278524582
	for <lists+linux-fscrypt@lfdr.de>; Thu, 12 May 2022 08:19:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349993AbiELGTR (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 12 May 2022 02:19:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239775AbiELGTQ (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 12 May 2022 02:19:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 427AC140435;
        Wed, 11 May 2022 23:19:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F1E4CB82701;
        Thu, 12 May 2022 06:19:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D84BC385B8;
        Thu, 12 May 2022 06:19:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652336353;
        bh=qOyBPK7TljuAhSrqbpM1O6XdNl/pRG4gfpH6MySft30=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rMGJhmWwGhuEOAxU/G9IM2KhVWGEpF75e2bPDyHEBqUTMaq0XxGUmQnlFh4K/Cw0D
         s113JAqy8t2S67WDVFdU92bgXLuU+jdNjBfbMYKfrNMSGAN5gmPNwniqgEt8v1M5+n
         ++RKu3MT0VmF3KduC4QivpQ1AdUyVybz83mOtMdVraPklhVX+p78PatrDKu6m46KT8
         7owaBHE8lhGEImrGZ7FDVJsbmv26h/MVmd/GzR/dlheQjbiFdvrOKc9SjAcB7dLEH2
         IHCb8Cr8/vxdx0XGXgDM2VHKiGaiFeWBe3oBbb+vDlF9CBjK/y2yPdmGnCLO4xefP/
         j0B3MQ8trl4TA==
Date:   Wed, 11 May 2022 23:19:11 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Mimi Zohar <zohar@linux.ibm.com>
Cc:     linux-integrity@vger.kernel.org,
        Stefan Berger <stefanb@linux.ibm.com>,
        linux-fscrypt@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v9 7/7] fsverity: update the documentation
Message-ID: <Ynym39Y++2zAiWOx@sol.localdomain>
References: <20220505123141.1599622-1-zohar@linux.ibm.com>
 <20220505123141.1599622-8-zohar@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220505123141.1599622-8-zohar@linux.ibm.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Thu, May 05, 2022 at 08:31:41AM -0400, Mimi Zohar wrote:
> Update the fsverity documentation related to IMA signature support.
> 
> Acked-by: Stefan Berger <stefanb@linux.ibm.com>
> Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
> ---
>  Documentation/filesystems/fsverity.rst | 35 +++++++++++++++++---------
>  1 file changed, 23 insertions(+), 12 deletions(-)

Acked-by: Eric Biggers <ebiggers@google.com>

- Eric
