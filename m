Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1EEF174BC34
	for <lists+linux-fscrypt@lfdr.de>; Sat,  8 Jul 2023 07:38:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230107AbjGHFiL (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sat, 8 Jul 2023 01:38:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233039AbjGHFhc (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Sat, 8 Jul 2023 01:37:32 -0400
Received: from mail-qv1-xf2f.google.com (mail-qv1-xf2f.google.com [IPv6:2607:f8b0:4864:20::f2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BCDC26A8
        for <linux-fscrypt@vger.kernel.org>; Fri,  7 Jul 2023 22:37:03 -0700 (PDT)
Received: by mail-qv1-xf2f.google.com with SMTP id 6a1803df08f44-635e5b06aaeso16513416d6.0
        for <linux-fscrypt@vger.kernel.org>; Fri, 07 Jul 2023 22:37:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1688794622; x=1691386622;
        h=in-reply-to:references:subject:cc:to:from:message-id:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Z6/SL5QIc9OziszvZ8u03wi1DZHVgI7E++JsfeAk1ow=;
        b=N3GcVG1FDP/U4zI33j/s/ZPDElJlG1FTWT2qAeOAqZZcIpJGqcLEQFLywR9QELr4tx
         hEZ42jpKvn99UxuTEx85166xgkvcrhd7sW+0CAjhCYUI0KBK4kPHsnl5fjy2K8iPOK9Y
         1Az8rufTzbfjqSl7326GH2mwzXNmtFdOsx0+mWv+TVL9tyX3bi5OYiZ5L4g3BwY2rNJZ
         iVybNFziEHZGs5Gw81G2muX9prmr7V1Z2N4WUDN45w6np73MhBdQOnODt5WE99Qc0YhR
         TuiwwrSDA7qlZfarpBEUkFtaYBCD+zjdJ0qb+ym09wRq7D2QHTSGgOWH0k8L/zi7c9Lv
         vmUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688794622; x=1691386622;
        h=in-reply-to:references:subject:cc:to:from:message-id:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Z6/SL5QIc9OziszvZ8u03wi1DZHVgI7E++JsfeAk1ow=;
        b=dehrdltkGjh+7GfTk2c76gopb6EtWleWyRneV16k0kMogfKGaW3ARjzRB5dIV9/gcq
         Wam21RFMR79rkXB34Alz4JVne3LxJIrE8QU3y8fWvCJpUMS4Hf1OmpVkEUPuHSMmY50U
         E4fgjGHZHyom+Zwt7QJNi0doT5cyoI+LLRnPjiWz2M6ej5yeIMylmTV0F9O0DfuUvFNr
         Pp10c6eziun67zCnKFhFpnNc/tNh11oyudgRv3UAeEE/ycoy5WvdvZn17vKB/BIdRdW9
         qbXuzeFexCbsgYQdLsWf+3EpWI6jFPlIhw8wyaBNoqdM54LX5YCgswoGfu+2lgqeIyNo
         Oe3g==
X-Gm-Message-State: ABy/qLaoGfNyb1REQN+diqv9aYik3tONQ5oR01Ks8ueDeQai7b7X4/ws
        bEY7nW7XxAvMyTNSur2YxbV/
X-Google-Smtp-Source: APBJJlHqj9++w6WHE9OOS1x/EIvxFYkNoud1COXwqkUYSG2/gyokLAhEcbs9dBviEyfunYwBG/R77Q==
X-Received: by 2002:a0c:da14:0:b0:636:e4f:6b9a with SMTP id x20-20020a0cda14000000b006360e4f6b9amr6374783qvj.17.1688794621936;
        Fri, 07 Jul 2023 22:37:01 -0700 (PDT)
Received: from localhost ([70.22.175.108])
        by smtp.gmail.com with ESMTPSA id m6-20020a0cdb86000000b006362c5760f8sm2952651qvk.139.2023.07.07.22.37.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Jul 2023 22:37:01 -0700 (PDT)
Date:   Sat, 08 Jul 2023 01:37:01 -0400
Message-ID: <b7334846cb475edd0e9b970a2bb011d7.paul@paul-moore.com>
From:   Paul Moore <paul@paul-moore.com>
To:     Fan Wu <wufan@linux.microsoft.com>, corbet@lwn.net,
        zohar@linux.ibm.com, jmorris@namei.org, serge@hallyn.com,
        tytso@mit.edu, ebiggers@kernel.org, axboe@kernel.dk,
        agk@redhat.com, snitzer@kernel.org, eparis@redhat.com
Cc:     linux-doc@vger.kernel.org, linux-integrity@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, linux-block@vger.kernel.org,
        dm-devel@redhat.com, audit@vger.kernel.org,
        roberto.sassu@huawei.com, linux-kernel@vger.kernel.org,
        Deven Bowers <deven.desai@linux.microsoft.com>,
        Fan Wu <wufan@linux.microsoft.com>
Subject: Re: [PATCH RFC v10 9/17] ipe: add permissive toggle
References: <1687986571-16823-10-git-send-email-wufan@linux.microsoft.com>
In-Reply-To: <1687986571-16823-10-git-send-email-wufan@linux.microsoft.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Jun 28, 2023 Fan Wu <wufan@linux.microsoft.com> wrote:
> 
> IPE, like SELinux, supports a permissive mode. This mode allows policy
> authors to test and evaluate IPE policy without it effecting their
> programs. When the mode is changed, a 1404 AUDIT_MAC_STATUS
> be reported.
> 
> This patch adds the following audit records:
> 
>     audit: MAC_STATUS enforcing=0 old_enforcing=1 auid=4294967295
>       ses=4294967295 enabled=1 old-enabled=1 lsm=ipe res=1
>     audit: MAC_STATUS enforcing=1 old_enforcing=0 auid=4294967295
>       ses=4294967295 enabled=1 old-enabled=1 lsm=ipe res=1
> 
> The audit record only emit when the value from the user input is
> different from the current enforce value.
> 
> Signed-off-by: Deven Bowers <deven.desai@linux.microsoft.com>
> Signed-off-by: Fan Wu <wufan@linux.microsoft.com>
> ---
>  security/ipe/audit.c | 22 ++++++++++++++
>  security/ipe/audit.h |  1 +
>  security/ipe/eval.c  |  9 ++++++
>  security/ipe/eval.h  |  1 +
>  security/ipe/fs.c    | 69 ++++++++++++++++++++++++++++++++++++++++++++
>  5 files changed, 102 insertions(+)

...

> diff --git a/security/ipe/fs.c b/security/ipe/fs.c
> index 6bd2aa84831b..1761d39e4d04 100644
> --- a/security/ipe/fs.c
> +++ b/security/ipe/fs.c
> @@ -16,6 +16,7 @@ static struct dentry *np __ro_after_init;
>  static struct dentry *root __ro_after_init;
>  struct dentry *policy_root __ro_after_init;
>  static struct dentry *audit_node __ro_after_init;
> +static struct dentry *enforce_node __ro_after_init;
>  
>  /**
>   * setaudit - Write handler for the securityfs node, "ipe/success_audit"
> @@ -68,6 +69,61 @@ static ssize_t getaudit(struct file *f, char __user *data,
>  	return simple_read_from_buffer(data, len, offset, result, 1);
>  }
>  
> +/**
> + * setenforce - Write handler for the securityfs node, "ipe/enforce"
> + * @f: Supplies a file structure representing the securityfs node.
> + * @data: Supplies a buffer passed to the write syscall.
> + * @len: Supplies the length of @data.
> + * @offset: unused.
> + *
> + * Return:
> + * * >0	- Success, Length of buffer written
> + * * <0	- Error
> + */
> +static ssize_t setenforce(struct file *f, const char __user *data,
> +			  size_t len, loff_t *offset)
> +{
> +	int rc = 0;
> +	bool new_value, old_value;
> +
> +	if (!file_ns_capable(f, &init_user_ns, CAP_MAC_ADMIN))
> +		return -EPERM;
> +
> +	old_value = READ_ONCE(enforce);
> +	new_value = old_value;

Why set @new_value equal to @old_value here?

> +	rc = kstrtobool_from_user(data, len, &new_value);
> +	if (rc)
> +		return rc;
> +
> +	if (new_value != old_value) {
> +		ipe_audit_enforce(new_value, old_value);
> +		WRITE_ONCE(enforce, new_value);
> +	}
> +
> +	return len;
> +}

--
paul-moore.com
