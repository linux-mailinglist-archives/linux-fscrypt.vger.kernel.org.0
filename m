Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E35464E30FC
	for <lists+linux-fscrypt@lfdr.de>; Mon, 21 Mar 2022 20:55:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352863AbiCUT4d (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 21 Mar 2022 15:56:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345508AbiCUT4c (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 21 Mar 2022 15:56:32 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE6EA17DCAA;
        Mon, 21 Mar 2022 12:55:06 -0700 (PDT)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22LH54wR025664;
        Mon, 21 Mar 2022 19:55:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=zzkk0Cavuwgion3kRcBj//QDAEjpYKPp71kE0k9l67k=;
 b=DlFaZSrNMHgEoaBCZuuj/+Lj+lexznE3HLSGEXxplLmehJrurA6OVukAsZTqDSpXitMQ
 nEJ+4pVmjMz1R3tNZmmjciHZ/cBEGm8hGyofSbCSbD39OQPuDEJtO4+B/SP5qf7bBhC8
 jk5jHkQWwks9IbLdGCZgosvCQUyq3WYuVdUj8GnCQGf72Lfal/jPGxgBxvD0QH6BGiUp
 8XHwGkA8k+0B8Uvm3D5s3r2oFswQ0x6+LRbQpn/wJ5Tz8zWWS8KNQkcPEeXaXVYCK+AP
 QaoYm408ByD+ZM+KtaK9Fm9PHnVEtHY3XeihWGJCnDLugfdDGsxzbbOJQKT84/Mfpfb8 dA== 
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3exbykfdxk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Mar 2022 19:55:03 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 22LJlX9B027857;
        Mon, 21 Mar 2022 19:55:01 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma04ams.nl.ibm.com with ESMTP id 3ew6t8vmxq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Mar 2022 19:55:01 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 22LJsxT044695970
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Mar 2022 19:54:59 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 12EE142045;
        Mon, 21 Mar 2022 19:54:59 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4367642041;
        Mon, 21 Mar 2022 19:54:58 +0000 (GMT)
Received: from sig-9-65-71-84.ibm.com (unknown [9.65.71.84])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 21 Mar 2022 19:54:58 +0000 (GMT)
Message-ID: <23ac7b16909bd9b86e7a65ade6a526bf46bdb734.camel@linux.ibm.com>
Subject: Re: [PATCH v6 3/5] ima: permit fsverity's file digests in the IMA
 measurement list
From:   Mimi Zohar <zohar@linux.ibm.com>
To:     Stefan Berger <stefanb@linux.ibm.com>,
        linux-integrity@vger.kernel.org
Cc:     Eric Biggers <ebiggers@kernel.org>, linux-fscrypt@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Mon, 21 Mar 2022 15:54:57 -0400
In-Reply-To: <1e9263cb-8a3e-a3d8-01c8-0893934f8235@linux.ibm.com>
References: <20220318182151.100847-1-zohar@linux.ibm.com>
         <20220318182151.100847-4-zohar@linux.ibm.com>
         <1e9263cb-8a3e-a3d8-01c8-0893934f8235@linux.ibm.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.28.5 (3.28.5-18.el8) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: F7WQXr0nvHXN_27kI-3jV7LnlnAtqN4e
X-Proofpoint-ORIG-GUID: F7WQXr0nvHXN_27kI-3jV7LnlnAtqN4e
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-21_07,2022-03-21_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 suspectscore=0
 mlxscore=0 mlxlogscore=999 priorityscore=1501 lowpriorityscore=0
 malwarescore=0 adultscore=0 impostorscore=0 phishscore=0 bulkscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203210124
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Mon, 2022-03-21 at 08:59 -0400, Stefan Berger wrote:

> > +/*
> > + * Make sure the policy rule and template format are in sync.
> If they are not in sync I need to update my policy rule?

It doesn't prevent loading the policy, if they're not in sync, but
simply issues a warning.

> 
> > + */
> > +static void check_template_field(const struct ima_template_desc *template,
> > +				 const char *field, const char *msg)
> > +{
> > +	int i;
> > +
> > +	for (i = 0; i < template->num_fields; i++)
> > +		if (!strcmp(template->fields[i]->field_id, field))
> > +			return;
> > +
> > +	pr_notice_once("%s", msg)
> > +}
> > +
> >   static bool ima_validate_rule(struct ima_rule_entry *entry)
> >   {
> >   	/* Ensure that the action is set and is compatible with the flags */
> > @@ -1215,7 +1232,8 @@ static bool ima_validate_rule(struct ima_rule_entry *entry)
> >   				     IMA_INMASK | IMA_EUID | IMA_PCR |
> >   				     IMA_FSNAME | IMA_GID | IMA_EGID |
> >   				     IMA_FGROUP | IMA_DIGSIG_REQUIRED |
> > -				     IMA_PERMIT_DIRECTIO | IMA_VALIDATE_ALGOS))
> > +				     IMA_PERMIT_DIRECTIO | IMA_VALIDATE_ALGOS |
> > +				     IMA_VERITY_REQUIRED))
> >   			return false;
> >   
> >   		break;
> > @@ -1708,6 +1726,13 @@ static int ima_parse_rule(char *rule, struct ima_rule_entry *entry)
> >   						   LSM_SUBJ_TYPE,
> >   						   AUDIT_SUBJ_TYPE);
> >   			break;
> > +		case Opt_digest_type:
> > +			ima_log_string(ab, "digest_type", args[0].from);
> > +			if ((strcmp(args[0].from, "verity")) == 0)
> > +				entry->flags |= IMA_VERITY_REQUIRED;
> > +			else
> > +				result = -EINVAL;
> > +			break;
> >   		case Opt_appraise_type:
> >   			ima_log_string(ab, "appraise_type", args[0].from);
> >   			if ((strcmp(args[0].from, "imasig")) == 0)
> > @@ -1798,6 +1823,15 @@ static int ima_parse_rule(char *rule, struct ima_rule_entry *entry)
> >   		check_template_modsig(template_desc);
> >   	}
> >   
> > +	/* d-ngv2 template field recommended for unsigned fs-verity digests */
> > +	if (!result && entry->action == MEASURE &&
> > +	    entry->flags & IMA_VERITY_REQUIRED) {
> > +		template_desc = entry->template ? entry->template :
> > +						  ima_template_desc_current();
> > +		check_template_field(template_desc, "d-ngv2",
> > +				     "verity rules should include d-ngv2");
> > +	}
> > +
> >   	audit_log_format(ab, "res=%d", !result);
> >   	audit_log_end(ab);
> >   	return result;
> > @@ -2155,6 +2189,8 @@ int ima_policy_show(struct seq_file *m, void *v)
> >   		else
> >   			seq_puts(m, "appraise_type=imasig ");
> >   	}
> > +	if (entry->flags & IMA_VERITY_REQUIRED)
> > +		seq_puts(m, "digest_type=verity ");
> >   	if (entry->flags & IMA_CHECK_BLACKLIST)
> >   		seq_puts(m, "appraise_flag=check_blacklist ");
> >   	if (entry->flags & IMA_PERMIT_DIRECTIO)
> > diff --git a/security/integrity/ima/ima_template_lib.c b/security/integrity/ima/ima_template_lib.c
> > index bd95864a5f6f..0cff6658a4c2 100644
> > --- a/security/integrity/ima/ima_template_lib.c
> > +++ b/security/integrity/ima/ima_template_lib.c
> > @@ -31,7 +31,7 @@ enum data_formats {
> >   };
> >   
> >   #define DIGEST_TYPE_MAXLEN 16	/* including NULL */
> > -static const char * const digest_type_name[] = {"ima"};
> > +static const char * const digest_type_name[] = {"ima", "verity"};
> >   static int digest_type_size = ARRAY_SIZE(digest_type_name);
> 
> if this static needs to exist at all, and I dn't think it should, it 
> should probably be called digest_type_array_size. Though I would just 
> use ARRAY_SIZE() where needed.

Ok.

thanks,

Mimi


