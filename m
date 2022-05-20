Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0C3752E48C
	for <lists+linux-fscrypt@lfdr.de>; Fri, 20 May 2022 07:54:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345114AbiETFxy (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 20 May 2022 01:53:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231455AbiETFxu (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 20 May 2022 01:53:50 -0400
Received: from fornost.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9B12C1EFC;
        Thu, 19 May 2022 22:53:48 -0700 (PDT)
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1nrva3-00Fhx1-Ai; Fri, 20 May 2022 15:53:44 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 20 May 2022 13:53:43 +0800
Date:   Fri, 20 May 2022 13:53:43 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Nathan Huckleberry <nhuck@google.com>
Cc:     linux-crypto@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        linux-arm-kernel@lists.infradead.org,
        Paul Crowley <paulcrowley@google.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Sami Tolvanen <samitolvanen@google.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Eric Biggers <ebiggers@google.com>
Subject: Re: [PATCH v8 8/9] crypto: arm64/polyval: Add PMULL accelerated
 implementation of POLYVAL
Message-ID: <Yocs5y9rvJJ+eI6C@gondor.apana.org.au>
References: <20220510172359.3720527-1-nhuck@google.com>
 <20220510172359.3720527-9-nhuck@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220510172359.3720527-9-nhuck@google.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Tue, May 10, 2022 at 05:23:58PM +0000, Nathan Huckleberry wrote:
>
> +module_cpu_feature_match(PMULL, polyval_ce_mod_init)
> +
> +module_init(polyval_ce_mod_init);

I get a cross-compile failure on this:

In file included from ../arch/arm64/crypto/polyval-ce-glue.c:25:
../include/linux/module.h:131:42: error: redefinition of ‘__inittest’
  131 |  static inline initcall_t __maybe_unused __inittest(void)  \
      |                                          ^~~~~~~~~~
../arch/arm64/crypto/polyval-ce-glue.c:187:1: note: in expansion of macro ‘module_init’
  187 | module_init(polyval_ce_mod_init);
      | ^~~~~~~~~~~
../include/linux/module.h:131:42: note: previous definition of ‘__inittest’ was here
  131 |  static inline initcall_t __maybe_unused __inittest(void)  \
      |                                          ^~~~~~~~~~
../include/linux/cpufeature.h:55:1: note: in expansion of macro ‘module_init’
   55 | module_init(cpu_feature_match_ ## x ## _init)
      | ^~~~~~~~~~~
../arch/arm64/crypto/polyval-ce-glue.c:185:1: note: in expansion of macro ‘module_cpu_feature_match’
  185 | module_cpu_feature_match(PMULL, polyval_ce_mod_init)
      | ^~~~~~~~~~~~~~~~~~~~~~~~
../include/linux/module.h:133:6: error: redefinition of ‘init_module’
  133 |  int init_module(void) __copy(initfn)   \
      |      ^~~~~~~~~~~
../arch/arm64/crypto/polyval-ce-glue.c:187:1: note: in expansion of macro ‘module_init’
  187 | module_init(polyval_ce_mod_init);
      | ^~~~~~~~~~~
../include/linux/module.h:133:6: note: previous definition of ‘init_module’ was here
  133 |  int init_module(void) __copy(initfn)   \
      |      ^~~~~~~~~~~
../include/linux/cpufeature.h:55:1: note: in expansion of macro ‘module_init’
   55 | module_init(cpu_feature_match_ ## x ## _init)
      | ^~~~~~~~~~~
../arch/arm64/crypto/polyval-ce-glue.c:185:1: note: in expansion of macro ‘module_cpu_feature_match’
  185 | module_cpu_feature_match(PMULL, polyval_ce_mod_init)
      | ^~~~~~~~~~~~~~~~~~~~~~~~

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
