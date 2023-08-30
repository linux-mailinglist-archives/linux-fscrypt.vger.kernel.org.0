Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59DA078DD18
	for <lists+linux-fscrypt@lfdr.de>; Wed, 30 Aug 2023 20:53:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243321AbjH3Srm (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 30 Aug 2023 14:47:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343626AbjH3QUF (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 30 Aug 2023 12:20:05 -0400
X-Greylist: delayed 459 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 30 Aug 2023 09:20:02 PDT
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9776D2;
        Wed, 30 Aug 2023 09:20:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 8FC88CE1DF4;
        Wed, 30 Aug 2023 16:12:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45A35C433C8;
        Wed, 30 Aug 2023 16:12:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1693411937;
        bh=0Hkngm8ZW/ojcPrOWV8u3ze2lTHk3kOwiBOMn/Y/K6o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pGNhVF4H6TQWNJ5tuDbFnoCmRuS7oKWmWUlaWAjTByszeDDGB/cRDFKQp7vKGCzTW
         niUljb1RnH3Mv7XDlPt9SjXCF4kE0SyRmw6fAzCt9lrO5rULL4luSdXgtNtahjQocs
         TOvtktG5A96bfAkB9BBCGYYKGTWrkzy2AkjM8sVxyq25w7/xBpkKKLbB3tDsIgo42s
         IJLmhDZKaLQodepWHe6o14r1+36GYZtP9nMKR4vS7rSazSEGP5WeoY4piP7DQ2siNf
         siZ04cqn6dgH9KRlxs4Jrs7zdZ4nozKoH9G428sIfd8E9L5u0oJL6b/sKMe6ZmU4mV
         83l3ASVZb4SrA==
Date:   Wed, 30 Aug 2023 09:12:15 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Cc:     Gaurav Kashyap <quic_gaurkash@quicinc.com>,
        linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-mmc@vger.kernel.org, linux-block@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, omprsing@qti.qualcomm.com,
        quic_psodagud@quicinc.com, avmenon@quicinc.com,
        abel.vesa@linaro.org, quic_spuppala@quicinc.com
Subject: Re: [PATCH v2 00/10] Hardware wrapped key support for qcom ice and
 ufs
Message-ID: <20230830161215.GA893@sol.localdomain>
References: <20230719170423.220033-1-quic_gaurkash@quicinc.com>
 <f4b5512b-9922-1511-fc22-f14d25e2426a@linaro.org>
 <20230825210727.GA1366@sol.localdomain>
 <f63ce281-1434-f86f-3f4e-e1958a684bbd@linaro.org>
 <20230829181223.GA2066264@google.com>
 <2230571a-114c-0d03-d02a-fa08c2a8d483@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2230571a-114c-0d03-d02a-fa08c2a8d483@linaro.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Wed, Aug 30, 2023 at 11:00:07AM +0100, Srinivas Kandagatla wrote:
> 
> 3. We are adding these apis/callbacks in common code without doing any
> compatible or SoC checks. Is this going to be a issue if someone tries
> fscrypt?

ufs-qcom only declares support for wrapped keys if it's supported.  See patch 5
of this series:

+	if (qcom_ice_hwkm_supported(host->ice))
+		hba->quirks |= UFSHCD_QUIRK_USES_WRAPPED_CRYPTO_KEYS;

That in turn uses:

+bool qcom_ice_hwkm_supported(struct qcom_ice *ice)
+{
+	return (ice->hwkm_version > 0);
+}
+EXPORT_SYMBOL_GPL(qcom_ice_hwkm_supported);

Which in turn comes from the ICE version being >= 3.2.  It does seem a bit
suspicious; it probably should check for both the ICE version and the
availability of QCOM_SCM_ES_GENERATE_ICE_KEY, QCOM_SCM_ES_PREPARE_ICE_KEY, and
QCOM_SCM_ES_IMPORT_ICE_KEY.  Regardless, it sounds like you want it to be
determined by something set in the device tree instead?  I don't think it's been
demonstrated that that's necessary.  If we can detect the hardware capabilities
dynamically, we should do that, right?

- Eric
